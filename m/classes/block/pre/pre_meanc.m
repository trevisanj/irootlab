%> @brief Mean-centering (trained)
%>
%> Descends from pre_norm_base to organize in GUI but is unrelated to other pre_norm_*
classdef pre_meanc < pre_norm_base
    properties(SetAccess=protected)
        means = [];
    end;
    
    methods
        function o = pre_meanc(o)
            o.classtitle = 'Trained Mean-centering';
            o.short = 'MeanC';
            o.flag_trainable = 1;
            o.flag_params = 0;
        end;
    end;
    
    methods(Access=protected)

        
        % Trains the block: records the variable means
        function o = do_train(o, data)
            o.means = mean(data.X, 1);
        end;
        
        % Applies block to dataset
        function data = do_use(o, data)
            X = data.X;
            data.X = X-repmat(o.means, size(X, 1), 1);
        end;
    end;
end