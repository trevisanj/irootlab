%> @brief area
classdef fcon_mea_area < fcon_mea
    methods
        function o = fcon_mea_area(o)
            o.classtitle = 'Area';
            o.flag_params = 0;
        end;
    end;
    
    methods(Access=protected)
        function data = do_use(o, data)
            data.fea_x = 1;
            data.X = sum(data.X, 2);
        end;
    end;
end
