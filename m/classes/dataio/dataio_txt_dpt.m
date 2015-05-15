%> @brief DPT TXT *loader* only
%>
%> DPT - Data Points Table
%>
%> Format saved by OPUS. First column is wavenumbers, then subsequence columns
%> are spectra. 
%>
%> </ul>
classdef dataio_txt_dpt < dataio
    properties
        %> (optional) Image height. If specified, will assign it the loaded dataset
        height = [];
        %> ='hor'. Whether the pixels are taken horizontally ('hor') or vertically ('ver') to form the image.
        %> It was found that OPUS numbers the point in the image map left-right, bottom-up, hence 'hor'.
        %> Same as irdata.direction (although irdata.direction has a different default).
        direction = 'hor';
    end;
    
    
    methods
        function o = dataio_txt_dpt()
            o.flag_params = 1; % uip_data_txt.dpt.(fig/m)
        end;
        
        %> Loader
        function ds = load(o)
            Q = load(o.filename);
            fea_x = Q(:, 1)';
            X = Q(:, 2:end)';


            ds = irdata();
            ds.filename = o.filename;
            ds.filetype = 'txt_dpt';
            ds.X = X;
            mask = ['p%0', int2str(ceil(log10(ds.no))), 'd'];
            ds.obsnames = arrayfun(@(i) sprintf(mask, i), (0:ds.no-1)', 'UniformOutput', 0);
            ds.fea_x = fea_x;
            ds = ds.assert_fix();
            if ~isempty(o.height)
                ds.height = o.height;
                ds.direction = o.direction;
            end;
            ds.assert_not_nan();
        end;
        
        %> Saver
        function o = save(o, data)
            irerror('Sorry, DPT saving not supported at the moment.');
        end;
    end
end