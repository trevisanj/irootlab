%> @brief Standardization (trained)
%>
%> Descends from pre_norm_base to organize in GUI but is unrelated to other pre_norm_*
classdef pre_std < pre_norm_base
    properties(SetAccess=private)
        means = [];
        stds = [];
    end;
    
    methods
        function o = pre_std(o)
            o.classtitle = 'Standardization';
            o.short = 'Std';
            o.flag_trainable = 1;
            o.flag_params = 0;
        end;
    end;
    
    methods(Access=protected)
        % Trains block: records variable means and standard deviations
        function o = do_train(o, data)
            o.means = mean(data.X, 1);
            o.stds = std(data.X, 1);
        end;
        
        
        % Applies block to dataset
        function data = do_use(o, data)
            data.X = bsxfun(@rdivide, bsxfun(@minus, data.X, o.means), o.stds+realmin);
        end;
    end;
end