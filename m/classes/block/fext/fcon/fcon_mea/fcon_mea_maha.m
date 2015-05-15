%> @brief Mahalanobis distance
classdef fcon_mea_maha < fcon_mea
    properties
    end;

    methods
        function o = fcon_mea_maha(o)
            o.classtitle = 'Mahalanobis Distance';
            o.flag_params = 0;
        end;
    end;
    
    methods(Access=protected)
        function data = do_use(o, data)
            data.fea_x = 1;
            data.X = maha(data.X);
        end;
    end;
end
