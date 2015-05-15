%> @brief Estimation Aggregator - combines @ref estimato objects together.
classdef esag < rowaggr
    properties
        %> =0. Minimum maximum probability. If not reached, all probabilities of item will be flattened to zero.
        threshold = 0;
    end;
    
    methods
        function o = esag(o)
            o.classtitle = 'Estimation Aggregator';
            o.flag_trainable = 0;
            o.flag_params = 0;
        end;
    end;
    
    methods(Access=protected)
        function dd = apply_threshold(o, dd)
            if o.threshold > 0
                for i = 1:numel(dd)
                    MM = max(dd(i).X, [], 2);
                    idxs = MM < o.threshold;
                    dd(i).X(idxs, :) = zeros(sum(idxs), dd(i).nf);
                end;
            end;   
        end;        
        
        
        %> Abstract
        function out = do_use(o, dd)
        end;
    end;
end