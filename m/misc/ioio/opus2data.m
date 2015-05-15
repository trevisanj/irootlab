%>@ingroup ioio
%>@file
%> @brief Merges several OPUS binary files into a dataset
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
function [data, flag_error] = opus2data(wild, trimdot, flag_image, height)
if ~exist('trimdot')
    trimdot = 2;
end;

[filenames, groupcodes] = resolve_dir(wild, trimdot, flag_image);

no_files = length(filenames);

if flag_image
    if no_files/height ~= floor(no_files/height)
        irerror('Opus2Data: Invalid image height!');
    end;
end;


path_ = fileparts(wild);

data = irdata();

namestotry = {'Ratio', 'RatioChanged', 'RatioAbsorption'};
idxs = 1:numel(namestotry);
idxsnow = idxs;

flag_first = 1;
ipro = progress2_open('OPUS2DATA', [], 0, no_files);
cnt_error = 0;
errors = {};
ii = 0;
for i = 1:no_files
    filename = fullfile(path_, filenames{i});
    flag_imported = 0; % whether file was imported successfully
    lastmsg = '';
    lastME = 0;
    for j = 1:numel(namestotry)
        flag_break = 0;
        try
            [Y, X] = ImportOpus(filename, namestotry{idxsnow(j)}); % Jake's code is currently not closing the handle if it throws an exception
            
            fclose('all');
            
            if isempty(Y)
                lastmsg = 'Although the file opened, the import function returned empty';
                flag_break = 1;
            else
                if j > 1
                    temp = idxsnow;  % Makes priority to data block that was found in one file
                    temp(j) = [];
                    idxsnow = [idxsnow(j), temp];
                end;

                flag_break = 1;
                flag_imported = 1;
            end;
        catch ME
            fclose('all');
            lastmsg = ME.message;
            lastME = ME;
        end;
        
        if flag_break
            break;
        end;
    end;
    
    if ~flag_imported
        irverbose(sprintf('Not possible to read file %s. Last error message was ''%s''', filename, lastmsg), 3);
        if isa(lastME, 'MException')
            irverbose(lastME.getReport());
        end;
        cnt_error = cnt_error+1;
        errors{end+1} = filename;
    else
        if length(Y) < numel(Y)
            irverbose(sprintf('File "%s" has more than one spectrum', filename), 3);
            cnt_error = cnt_error+1;
            errors{end+1} = filename;
        else
            flag_put = 1;
            if flag_first
                % Initializes dataset if first row
                
                nf = length(X);

                data.fea_x = X;
                data.X = zeros(no_files, nf);
                data.classes = zeros(no_files, 1);
                data.obsnames = cell(no_files, 1);
                data.groupcodes = cell(no_files, 1);
                data.classlabels = {'Class 0'};
                flag_first = 0;
                
            else
                if length(Y) ~= nf
                    irverbose(sprintf('Wrong number of data points (%d) in file "%s" (should be %d)!', length(Y), filenames{i}, nf), 3);
                    flag_put = 0;
                end;
            end;
            
            if flag_put
                ii = ii+1;
                data.X(ii, :) = Y;
                data.classes(ii) = 0;
                data.obsnames{ii} = filenames{i};
                data.groupcodes{ii} = groupcodes{i};
            end;
        end;
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



