%>@ingroup ioio
%>@file
%> @brief Merges several "Pirouette .dat" files into a dataset
%>
%> @c data.groupcodes is made from file name. File name is trimmed at the trimdot-th dot counted from right to left. E.g., 
%> This allows one to trim "sample.0.dat" at the penultimate dot (ignodedoctount=2) or "sample.dat" at the last dot
%> (trimdot=1)
%>
%> data.obsnames will contain the file names
%>
%> For reference on parameters, please check @ref mergetool.m
%>
%> @sa mergetool.m

%> @param wild
%> @param trimdot See pirtool
%> @param flag_image
%> @param height
%> @return A dataset
function [data, flag_error] = pir2data(wild, trimdot, flag_image, height)

if ~exist('trimdot', 'var')
    trimdot = 2;
end;

[filenames, groupcodes] = resolve_dir(wild, trimdot, flag_image);

no_files = length(filenames);

if flag_image
    if no_files/height ~= floor(no_files/height)
        irerror('Pir2Data: Invalid image height!');
    end;
end;


idxs = find(wild == '/');
if isempty(idxs)
    path_ = '';
else
    path_ = wild(1:idxs(end));
end;
data = irdata();

flag_first = 1;
ipro = progress2_open('PIR2DATA', [], 0, no_files);
cnt_error = 0;
errors = {};
ii = 0;
for i = 1:no_files
    filename = fullfile(path_, filenames{i});
    flag_open = 0;
    try
        h = fopen(filename, 'r');
        if h < 0
            irerror(sprintf('Pir2Data: Could not open file ''%s''!', filename));
        end;
        flag_open = 1;

        fprintf('%d/%d: %s ...\n', i, no_files, filenames{i});

        flag_wants_wns = 1;
        flag_wants_point = 0;

        x = [];
        cnt_point = 0;
        while 1
            s = fgets(h);
            if isnumeric(s) && s == -1 % EOF
                break;
            end;

            flag_wns = 0;
            flag_point = 0;

            if s(1) == '#'
                if s(2) == 'c'
                    flag_wns = 1;
                end;
            else
                flag_point = 1;
            end;

            if flag_wns && ~flag_wants_wns
                irerror(sprintf('Pir2Data: Found wavenumbers specification but expecting something else in file ''%s''!', filenames{i}));
            end;
            if flag_point && ~flag_wants_point
                irerror(sprintf('Pir2Data: Found y-value but expecting something else in file ''%s''!', filenames{i}));
            end;

            if flag_wns
                if flag_first
                    wns = eval(['[' s(4:end) ']']);
                    wns_global = wns;
                    nf = length(wns_global);
                end;

                flag_wants_point = 1;
                flag_wants_wns = 0;
            elseif flag_point
                cnt_point = cnt_point+1;
                x(cnt_point) = eval(s);
            end;
        end;
        fclose(h);
        flag_open = 0;

        if flag_wants_wns
            irerror('Pir2Data: Wavenumbers specification not found in file ''%s''!', filenames{i});
        end;

        if nf == cnt_point
            if flag_first
                % Initializes dataset if first row
                data.X = zeros(no_files, nf);
                data.classes = zeros(no_files, 1);
                data.obsnames = cell(no_files, 1);
                data.groupcodes = cell(no_files, 1);
                data.fea_x = wns;
                data.classlabels = {'Class 0'};
                flag_first = 0;
            end;

            ii = ii+1;
            data.X(ii, :) = x;
            data.classes(ii) = 0;
            data.obsnames{ii} = filenames{i};
            data.groupcodes{ii} = groupcodes{i};
        else
            irerror('Pir2Data: Wrong number of data points in file ''%s''!', filenames{i});
        end;
    catch ME
        if flag_open
            fclose(h);
        end;
            
        %irverbose(['ERROR: ', ME.message]);
        irverbose(ME.getReport());
        cnt_error = cnt_error+1;
        errors{end+1} = filename;
    end;
    ipro = progress2_change(ipro, [], [], i);
end;
progress2_close(ipro);

flag_error = 0;
if cnt_error > 0
    irverbose(sprintf('NOTICE: only %d/%d files were successfully read. Import failed on following files:', no_files-cnt_error, no_files));
    for i = 1:cnt_error
        irverbose(errors{i});
    end;
    flag_error = cnt_error;
    
    data.X = data.X(1:ii, :);
    data.classes = data.classes(1:ii, :);
    data.obsnames = data.obsnames(1:ii, :);
    data.groupcodes = data.groupcodes(1:ii, :);
end;


if flag_image
    data.height = height;
end;

