%> @brief Basic TXT loader/saver
%>
%> Description of the "basic" file type (Figure 1):
%> <ul>
%>   <li>Table of data with no header and last column containing the class index.</li>
%>   <li>Delimiters such as ';', ' ', or '\t' (Tab) are supported.</li>
%> </ul>
%>
%> Because class labels and x-axis are not stored in the file,
%> <ul>
%>   <li>Class labels are made up as "Class 0", "Class 1" etc</li>
%>   <li>Unless the x-axis range is passed to load(), the default value [1801.47, 898.81] (Bruker Tensor27-aquired spectra, then cut to
%> 1800-900 region in OPUS)</li>
%>
%> @image html dataformat_basic.png
%> <center>Figure 1 - basic TXT file type</center>
%> </ul>
classdef dataio_txt_basic < dataio
    properties
        %> 2-element vector specifying the wavenumber range.
        %> This is necessary because this file format does not have this information.
        %> However, the parameter is optional (the default data fea_x will be
        %> [1, 2, 3, 4, ...])
        range = [];

        %> (optional) Image height. If specified, will assign it the loaded dataset
        height = [];
        %> ='hor'. Whether the pixels are taken horizontally ('hor') or vertically ('ver') to form the image.
        %> It was found that OPUS numbers the point in the image map left-right, bottom-up, hence 'hor'.
        %> Same as irdata.direction (although irdata.direction has a different default).
        direction = 'hor';
    end;
    
    methods
        function o = dataio_txt_basic()
            o.flag_xaxis = 0;
            o.flag_params = 1;
        end;

        
        
        %> Loader
        function data = load(o)
            [no_cols, delimiter] = get_no_cols_deli(o.filename);

            data = irdata();

            if isempty(o.range)
                data.fea_x = 1:no_cols-1;
            else
                data.fea_x = linspace(o.range(1), o.range(2), no_cols-1);
            end;



            % Mounts mask
            mask_data = [repmat('%f', 1, no_cols-1) '%q'];

            % Opens for the second time in order to actually read the file
            fid = fopen(o.filename);

            c_data = textscan(fid, mask_data, 'Delimiter', delimiter);
            fclose(fid);

            % Resolves easy one
            data.X = cell2mat(c_data(1:end-1));

            % Resolves classes
            clalpha = c_data{end};
            if ~iscell(clalpha)
                clalpha = cellfun(@num2str, num2cell(clalpha), 'UniformOutput', 0);
            end;
            data.classlabels = unique_appear(clalpha');
            
            no_obs = size(data.X, 1);
            data.classes(no_obs, 1) = -1; % pre-allocates
            for i = 1:no_obs
                data.classes(i) = find(strcmp(data.classlabels, clalpha{i}))-1;
            end;
            
            
            data.assert_not_nan();
            data.filename = o.filename;
            data.filetype = 'txt';
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

            labels = classes2labels(data.classes, data.classlabels);
            
            for i = 1:data.no
                fwrite(h, [sprintf('%g\t', data.X(i, :)) labels{i} sprintf('\n')]);
            end;

            fclose(h);
            
            irverbose(sprintf('Just saved file "%s"', o.filename), 2);
        end;
    end
end