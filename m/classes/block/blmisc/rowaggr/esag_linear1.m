%> @brief Estimation Aggregator - Linear Combination of datasets
classdef esag_linear1 < esag
    properties
        %> Weights of each dataset
        weights = [];
    end;
    methods
        function o = esag_linear1(o)
            o.classtitle = 'Dataset-Linear';
            o.inputclass = 'irdata';
        end;
    end;
    
    methods(Access=protected)
        %> Abstract
        function out = do_use(o, dd)
            dd = o.apply_threshold(dd);
            
            out = dd(1).copy_emptyrows();
            out = out.copy_from_data(dd(1));

            
            X = zeros(dd(1).no, dd(1).nf);
            if isempty(o.weights)
                weiyi = ones(1, numel(dd));
            else
                weiyi = o.weights;
            end;
            weiyi = weiyi/sum(weiyi);


            for i = 1:numel(dd)
                X = X+dd(i).X*weiyi(i);
            end;
            
            out.X = X;
        end;
    end;
end