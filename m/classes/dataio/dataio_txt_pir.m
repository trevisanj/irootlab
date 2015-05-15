%> @brief "Pirouette" TXT loader/saver
%>
%> This is how a dataset will look like by selecting the whole spreadsheet in Pirouette (Informetrix Inc.) and pasting
%> it into Excel. See Figure 1 for specification.
%>
%> @image html dataformat_pir.png
%> <center>Figure 1 - "Pirouette" TXT file type</center>
classdef dataio_txt_pir < dataio
    properties
        %> (optional) Image height. If specified, will assign it the loaded dataset
        height = [];
        %> ='hor'. Whether the pixels are taken horizontally ('hor') or vertically ('ver') to form the image.
        %> It was found that OPUS numbers the point in the image map left-right, bottom-up, hence 'hor'.
        %> Same as irdata.direction (although irdata.direction has a different default).
        direction = 'hor';
    end;

    methods
        %> Loader
        function data = load(o)

            data = irdata();
            
            [no_cols, delimiter] = get_no_cols_deli(o.filename);


            % Mounts masks
            mask_header = ['%q' repmat('%f', 1, no_cols-2) '%q'];

            mask_data = ['%q' repmat('%f', 1, no_cols-2) '%q'];

            % Opens for the second time in order to actually read the file
            fid = fopen(o.filename);
            c_header = textscan(fid, mask_header, 1, 'Delimiter', delimiter);
            x = cell2mat(c_header(2:end-1));
            trend = 0;
            for i = 2:length(x)
              if trend == 0
                  trend = sign(x(i)-x(i-1));
              elseif sign(x(i)-x(i-1)) ~= trend
                  irerror('There is something wrong with this text file!');
              end;
            end;



            c_data = textscan(fid, mask_data, 'Delimiter', delimiter);
            fclose(fid);

            % Resolves easy ones
            data.X = cell2mat(c_data(2:end-1));
            data.fea_x = x;

            % first column will be parsed to extract data.groupcodes
            % all content at first dot and beyond is discarded
            labels = c_data{1}; 
            no_obs = length(labels);
            data.groupcodes = cell(no_obs, 1);
            for i = 1:no_obs
                label = labels{i};
                idxs = regexp(label, '\.');

                if isempty(idxs)
                    idx = length(label)+1;
                else
                    idx = idxs(end); % The aim is to take everything before the last '.'
                end;

                data.groupcodes{i} = label(1:idx-1);
            end;
            


            % Resolves classes
            clalpha = c_data{end};
            if ~iscell(clalpha)
                clalpha = cellfun(@num2str, num2cell(clalpha), 'UniformOutput', 0);
            end;
            clalpha = cellfun(@strip_quotes, clalpha, 'UniformOutput', 0);
            data.classlabels = unique(clalpha)';
            
            data.classes(no_obs, 1) = -1; % pre-allocates
            for i = 1:no_obs
                data.classes(i) = find(strcmp(data.classlabels, clalpha{i}))-1;
            end;

            
            data.assert_not_nan();
            data.filename = o.filename;
            data.filetype = 'txt2';
            data = data.make_groupnumbers();
            if ~isempty(o.height)
                data.height = o.height;
                data.direction = o.direction;
            end;
        end;
    
        
        %> Saver
        function o = save(o, data)

            h = fopen(o.filename, 'w');
            if h < 1
                irerror(sprintf('Could not create file ''%s''!', o.filename));
            end;

            nel_group = size(data.groupcodes, 1);
            labels = classes2labels(data.classes, data.classlabels);

            fwrite(h, [sprintf('\t') sprintf('%g\t', data.fea_x) sprintf('\n')]);
            for i = 1:data.no
                if i > nel_group
                    groupcode = '';
                else
                    groupcode = data.groupcodes{i};
                end;
                fwrite(h, [groupcode sprintf('\t') sprintf('%g\t', data.X(i, :)) labels{i} sprintf('\n')]);
            end;

            fclose(h);
            
            irverbose(sprintf('Just saved file "%s"', o.filename), 2);
        end;
    end
end