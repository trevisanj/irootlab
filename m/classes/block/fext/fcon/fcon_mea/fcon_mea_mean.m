%> @brief mean
classdef fcon_mea_mean < fcon_mea
    methods
        function o = fcon_mea_mean(o)
            o.classtitle = 'Mean';
            o.flag_params = 0;
        end;
    end;
    
    methods(Access=protected)
        function data = do_use(o, data)
            data.fea_x = 1;
            data.X = mean(data.X, 2);
        end;
    end;
end
