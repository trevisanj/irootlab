%> @brief Decimation - makes averages of adjacent features
classdef fcon_feaavg < fcon
    properties
        %> = 2. Average every (factor) features. Curves will have floor(original_size*1/factor) number of point after averaging
        factor = 2;
    end;

    methods
        function o = fcon_feaavg(o)
            o.classtitle = 'Average features';
            o.flag_params = 1;
        end;
    end;
    
    methods(Access=protected)
        function data = do_use(o, data)
            data.fea_x = decim(data.fea_x, o.factor);
            data.X = decim(data.X, o.factor);
        end;
    end;
end
