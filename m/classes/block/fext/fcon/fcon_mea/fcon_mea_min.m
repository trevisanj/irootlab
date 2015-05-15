%> @brief Minimum over all features
classdef fcon_mea_min < fcon_mea
    properties
    end;

    methods
        function o = fcon_mea_min(o)
            o.classtitle = 'Minimum';
            o.flag_params = 0;
        end;
    end;
    
    methods(Access=protected)
        function data = do_use(o, data)
            data.fea_x = 1;
            data.X = min(data.X, [], 2);
        end;
    end;
end
