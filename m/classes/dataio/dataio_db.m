%> @file
%> @ingroup sheware
%
%> @brief Dataset loader/saver for the SHEWare database
classdef dataio_db < dataio
    properties
        idexperiment = [];
        iddomain = [];
        idjudge = [];
        iddeact = [];
        idtray = [];
    end;
    
    methods
        function data = load(o)
            flag_deact = ~isempty(o.iddeact);
            if flag_deact
                fielddeact = '(flag_inactive is null or flag_inactive = 0) as flag_active, ';
                fielddeact2 = 'flag_active';
                wheredeact = ' AND (flag_inactive is null or flag_inactive = 0)';
                ljdeact = [' LEFT JOIN deact_spectrum ON  deact_spectrum.idspectrum = spectrum.id and deact_spectrum.iddeact = ' mat2str(o.iddeact)];
            else
                fielddeact = '';
                fielddeact2 = '';
                wheredeact = '';
                ljdeact = '';
            end;
            

            disp('-- Doing the BIG select ... --')

            s_joins = [' LEFT JOIN series ON series.idspectrum = spectrum.id and series.iddomain = ' mat2str(o.iddomain) ljdeact ...
                ' LEFT JOIN colony ON colony.id = spectrum.idcolony'];
            
            s_fields = ['spectrum.id as idspectrum, spectrum.file_name, colony.id as colony_id, colony.code as colony_code, ' fielddeact 'series.vector, series.id as series_id'];
            a_outputs = [{'idspectrum', 'file_name', 'colony_id', 'colony_code'}, fielddeact2, {'vector', 'series_id'}];
            s_outputs_params = [];
            s_wheres = [' WHERE spectrum.idexperiment = ' mat2str(o.idexperiment) wheredeact];
            for i_judge = 1:length(o.idjudge)
                s_ij = mat2str(i_judge);
                fieldij = ['params' s_ij];
                s_fields = [s_fields ', sj' s_ij '.params as ' fieldij];
                s_joins = [s_joins ' LEFT JOIN spectrum_judge sj' s_ij ' on sj' s_ij '.idspectrum = spectrum.id and ' ...
                           'sj' s_ij '.idjudge = ' mat2str(o.idjudge(i_judge))];

                a_outputs = [a_outputs, fieldij];

                if ~isempty(s_outputs_params)
                    s_outputs_params = [s_outputs_params ', '];
                end;
                s_outputs_params = [s_outputs_params fieldij];
            end;

            
            if ~isempty(o.idtray)
                s_joins = [s_joins ' LEFT JOIN slide on slide.id = colony.idslide LEFT JOIN tray on tray.id = slide.idtray'];
                s_wheres = [s_wheres ' AND tray.id = ' int2str(o.idtray)];
            end;
            
            s_select = ['SELECT ' s_fields ' FROM spectrum ' s_joins s_wheres ' HAVING series.id > 0 ORDER BY spectrum.idcolony, spectrum.id'];
            disp(s_select);
            a = irquery(s_select); %#ok<NASGU>
            for i = 1:numel(a_outputs)
                eval([a_outputs{i}, ' = a.', a_outputs{i}, ';']);
            end;
            params_s = eval(['{' s_outputs_params '}']);

            disp('-- ... done --')

            no_obs = length(idspectrum);
            a = irquery(['select wncount, wn1, wn2 from domain where id = ' mat2str(o.iddomain)]);
            no_wn = a.wncount; wn1 = a.wn1; wn2 = a.wn2;
            no_judges = length(params_s);

            data = irdata(); % Creates new dataset object
            data.classlabels = {};
            data.fea_x = linspace(wn1, wn2, no_wn);
            X = zeros(no_obs, no_wn);
            data.classes = zeros(no_obs, 1);
            data.obsids = idspectrum;
            data.obsnames = file_name;
            data.groupcodes = colony_code;

            n = 1; % pointer over data
            nn = 0;

            cnt_ok = 0;

            for i_obs = 1:no_obs
                vchar = char(vector{i_obs})';
                if length(vchar) > 0

                    %--- resolves X
                    try
%                          X(i_obs, :) = str2num(['[' vchar ']']);
%                             X(i_obs, :) = str2double(regexp(vchar(2:end-1), ', ', 'split'));
                           X(i_obs, :) = sscanf(vchar, '%f', [1, no_wn]);
                    catch ME
                        rethrow ME;
                    end;

                    %--- resolves class
                    %       . mounts a code like "A|T"
                    code = '';
                    virg = '';
                    for i_judge = 1:no_judges
                        if i_judge == 2
                            virg = '|';
                        end;
                        code = [code virg strip_code(char(params_s{i_judge}{i_obs})')];
                    end;

                    %       . fits code in the dataset
                    find_indexes = find(strcmp(data.classlabels, code));
                    if isempty(find_indexes)
                        data.classlabels{end+1} = code;
                        data.classes(i_obs) = data.nc-1;
                    else
                        data.classes(i_obs) = find_indexes(1)-1;
                    end

                    % progress visual feedback
                    nn = nn+1;
                    if nn == 199 % arbitrary value
                        disp(sprintf('-- %5.1f %% --', i_obs/no_obs*100))
                        nn = 0;
                    end

                    cnt_ok = cnt_ok+1;
                end;
            end
            data.X = X;

            data.assert_not_nan();
            data = data_sort_classlabels(data);
            data = data.make_groupnumbers();


            fprintf('%d spectra were read\n', cnt_ok);
        end
    end
end
