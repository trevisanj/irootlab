%> @brief Maximum over all features
classdef fcon_mea_max < fcon_mea
    properties
    end;

    methods
        function o = fcon_mea_max(o)
            o.classtitle = 'Maximum';
            o.flag_params = 0;
        end;
    end;
    
    methods(Access=protected)
        function data = do_use(o, data)
            data.fea_x = 1;
            data.X = max(data.X, [], 2);
        end;
    end;
end
