%> @brief Saver in LIBSVM format (loading currently not implemented)
%>
%> See also README file of LIBSVM containing data format specification.
classdef dataio_txt_libsvm < dataio
    properties
        % The following properties affect the loading process and are unused at the moment
        
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
        function o = dataio_txt_libsvm()
            o.flag_xaxis = 0;
            o.flag_params = 1;
        end;

        
        
        %> Loader
        function data = load(o)
            irerror('Loading not implemented at the moment');
        end;
        
        
        
        %> Saver 
        function o = save(o, data)
            h = fopen(o.filename, 'w');
            if h < 1
                irerror(sprintf('Could not create file ''%s''!', o.filename));
            end;

            X = zeros(data.no, data.nf*2+1);
            X(:, 1) = data.classes;

            fmt = '%d';
            for j = 1:data.nf
                fmt = [fmt, '\t%d:%f'];
                X(:, j*2) = j;
                X(:, j*2+1) = data.X(:, j);
            end;
            fmt = [fmt, '\n'];

            fprintf(h, fmt, X');
            fclose(h);
            
            irverbose(sprintf('Just saved file "%s"', o.filename), 2);
        end;
    end
end