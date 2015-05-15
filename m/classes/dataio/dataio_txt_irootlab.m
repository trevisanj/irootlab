%> @brief IRootLab TXT loader/saver
%>
%> This file type is recommended if you want to edit the dataset in e.g. Excel, it is capable of storing all the properties of the dataset.
%>
%> See Figure 1 for example.
%>
%> @image html dataformat_iroot.png
%> <center>Figure 1 - Example of IRootLab TXT file open in a spreadsheet editing program.</center>
classdef dataio_txt_irootlab < dataio
    properties(SetAccess=protected)
        %> This affects saving: whether to save the classes as strings.
        %> This is set to 1 in dataio_txt_irootlab2
        flag_stringclasses = 0;
    end;
    methods
        function data = load(o)
            data = irdata();
            
            [no_cols, deli] = get_no_cols_deli(o.filename);
            mask = repmat('%q', 1, no_cols);
            
            fid = fopen(o.filename);
            flag_exp_header = 0;
            flag_exp_table = 0;
            fieldsfound = struct('name', {}, 'flag_cell', {}, 'idxs', {}, 'flag_classes', {});
            flag_stringclasses = 0;  % Whether classes are specified as strings or numbers
            
            while 1
                if flag_exp_table % expecting table
                    % reads everything, i.e., row fields
                    cc = textscan(fid, newmask, 'Delimiter', deli, 'CollectOutput', 0);
                    
                    for i = 1:length(fieldsfound)
                        fn = fieldsfound(i).name;
                        idxs = fieldsfound(i).idxs;
                        if fieldsfound(i).flag_classes
                            if any(cellfun(@(x) isempty(str2num(x)), cc{idxs}, 'UniformOutput', 1))
                                % Classes are expressed as strings
                                flag_stringclasses = 1; %#ok<*PROP>
                                clalpha = cc{idxs};
                                data.classlabels = unique_appear(clalpha');

                                no_obs = numel(clalpha);
                                data.classes(no_obs, 1) = -1; % pre-allocates
                                for i = 1:no_obs
                                    data.classes(i) = find(strcmp(data.classlabels, clalpha{i}))-1;
                                end;
                            else
                                % Classes are expressed as numbers
                                data.(fn) = cellfun(@str2num, cc{idxs}, 'UniformOutput', 1);
                            end;
                        elseif fieldsfound(i).flag_cell
                            data.(fn) = cc{idxs};
                        else
                            data.(fn) = cell2mat(cc(idxs));
                        end;
                    end;
                    break;
                else
                    % reads one line only
                    cc = textscan(fid, mask, 1, 'Delimiter', deli, 'CollectOutput', 1);
                    cc = cc{1};
                    if isempty(cc)
                        break;
                    end;
                end;
                
                if flag_exp_header
                    % goes through header to find which columns contain what
                    newmask = '';
                    num_fields = 0;
                    fn_now = '@#$!*%@!'; % Current field name
                    for i = 1:no_cols
                        s = strip_quotes(cc{i});
                        if ~strcmp(s, fn_now)
                            b = strcmp(s, data.rowfieldnames);
                            if any(b)
                                j = find(b); j = j(1);
                                num_fields = num_fields+1;
                                fieldsfound(num_fields).name = s;
                                flag_cell = data.flags_cell(j);
                                fieldsfound(num_fields).flag_cell = flag_cell;
                                fieldsfound(num_fields).flag_classes = strcmp(s, 'classes');
                                fn_now = s;
                            else
                                irerror(sprintf('Unknown field: "%s"', s));
                            end;
                        end;
                        fieldsfound(num_fields).idxs(end+1) = i;
                        newmask = [newmask, '%', iif(strcmp(s, 'classes') || flag_cell, 'q', 'f')]; %#ok<AGROW>
                    end;
                    flag_exp_header = 0;
                    flag_exp_table = 1;
                else
                    s = strip_quotes(cc{1});
                    if strcmp(s, 'classlabels')
                        try
                            data.classlabels = eval(strip_quotes(cc{2}));
                        catch ME
                            irerror(['Error trying to parse the "classlabels" property!', 10, 10, 'Original error:', 10, ME.message]);
                        end;
                            
                    elseif strcmp(s, 'fea_x')
                        % discards empty elements at the end of the cell
                        for i = length(cc):-1:1
                            if ~isempty(cc{i})
                                break;
                            end;
                        end;
                        cc = cc(2:i);
                        data.fea_x = str2double(cc);
                    elseif strcmp(s, 'table')
                        flag_exp_header = 1;
                    elseif strcmp(s, 'direction')
                        data.direction = strip_quotes(cc{2});
                    elseif strcmp(s, 'height')
                        data.height = str2num(strip_quotes(cc{2})); %#ok<*ST2NM>
                    elseif strcmp(s, 'title')
                        data.title = str2num(strip_quotes(cc{2})); %#ok<*ST2NM>
                    else
                        % Never mind
                    end;
                end;
            end;
            
            
            if ~flag_stringclasses
                % Makes sure claslabels is correct
                ncc = max(data.classes)+1;
                if ncc > numel(data.classlabels)
                    irverbose('WARNING: Number of classlabels lower than number of classes', 2);
                    nl = data.get_no_levels();
                    suffix = repmat('|1', 1, nl-1);
                    for i = numel(data.classlabels)+1:ncc
    %                     data.classlabels{i} = ['Class ', int2str(i-1), suffix];
                        data.classlabels{i} = [int2str(i-1), suffix];
                    end;
                end;

                data = data.eliminate_unused_classlabels();
            end;
            
            data.assert_not_nan();
            data.filename = o.filename;
            data.filetype = 'txt_irootlab';
            data = data.make_groupnumbers();
        end;
    
        
        %------------------------------------------------------------------
        % Saver
        function o = save(o, data)

            h = fopen(o.filename, 'w');
            if h < 1
                irerror(sprintf('Could not create file ''%s''!', o.filename));
            end;

            fieldidxs = [];
            fieldcols = [];
            no_cols = 0;
            no_fields = 0;
            flag_table = 1; % Whether any of the data.rowfieldnames is in use, otherwise table part of file won't be saved

            % goes through possible fields to find which ones are being used, and to determine number of columns for CSV
            % file
            for i = 1:length(data.rowfieldnames)
                if ~isempty(data.(data.rowfieldnames{i}))
                    fieldidxs(end+1) = i;
                    fieldcols(end+1) = size(data.(data.rowfieldnames{i}), 2);
                    no_cols = no_cols+fieldcols(end);
                    no_fields = no_fields+1;
                end;
            end;
            if no_cols == 0
                flag_table = 0;
                no_cols = length(data.fea_x)+1;
                if no_cols < 2
                    no_cols = 2;
                end;
            end;
            
            tab = sprintf('\t');
            newl = sprintf('\n');
            
            fwrite(h, ['IRootLab ' irootlab_version() repmat(tab, 1, no_cols-1) newl]);
            fwrite(h, ['title' tab data.title repmat(tab, 1, no_cols-2) newl]);
            if ~o.flag_stringclasses
                fwrite(h, ['classlabels' tab cell2str(data.classlabels) repmat(tab, 1, no_cols-2) newl]);
            end;
            temp = sprintf(['%g' tab], data.fea_x);
            fwrite(h, ['fea_x' tab temp(1:end-1) repmat(tab, 1, no_cols-data.nf-1) newl]);
            fwrite(h, ['height' tab int2str(data.height) repmat(tab, 1, no_cols-2) newl]);
            fwrite(h, ['direction' tab data.direction repmat(tab, 1, no_cols-2) newl]);
            fwrite(h, ['table' repmat(tab, 1, no_cols-1) newl]);
            
            

            if flag_table
                buflen = 1024; % writes every MB to disk
                buffer = repmat(' ', 1, buflen);
                ptr = 1;
                
                % table header
                for i = 1:no_fields
                    s = repmat([data.rowfieldnames{fieldidxs(i)} tab], 1, fieldcols(i));
                    buffer(ptr:ptr+length(s)-1) = s;
                    ptr = ptr+length(s);
                    if i == no_fields
                        ptr = ptr-1;% last tab won't count
                    end;
                end;
                buffer(ptr) = newl;
                ptr = ptr+1;
                flag_buffer = 1;
                
                if o.flag_stringclasses
                    labels = classes2labels(data.classes, data.classlabels);
                end;

                
                rowptr = 1;
                flag_calc_len = 0;
                rowlen = 0; % average row length
                while 1
                    if rowptr > data.no
                        break;
                    end;
                    
                    % data row
                    ptr_save = ptr;
                    for i = 1:no_fields
                        fn = data.rowfieldnames{fieldidxs(i)};
                        if strcmp(fn, 'classes') && o.flag_stringclasses
                            s = sprintf('%s\t', labels{rowptr});
                        else
                            if data.flags_cell(fieldidxs(i))
                                s = sprintf('%s\t', data.(fn){rowptr, :});
                            else
                                s = sprintf('%g\t', data.(fn)(rowptr, :));
                            end;
                        end;
                        buffer(ptr:ptr+length(s)-1) = s;
                        ptr = ptr+length(s);
                        if i == no_fields
                            ptr = ptr-1;% last tab won't count
                        end;
                    end;
                    buffer(ptr) = newl;
                    ptr = ptr+1;
                    rowlen = (rowlen*(rowptr-1)+(ptr-ptr_save))/rowptr;
                    flag_buffer = 1;

                    % tolerance of rowlen not to blow buffer
                    if ptr+2*rowlen > buflen
                        fwrite(h, buffer(1:ptr-1));
                        ptr = 1;
                        flag_buffer = 0;
                    end;
                    
                    rowptr = rowptr+1;
                end;
                
                if flag_buffer
                    fwrite(h, buffer(1:ptr-1));
                end;
            end;

            fclose(h);
            
            irverbose(sprintf('Just saved file "%s"', o.filename), 2);
        end;
    end
end
