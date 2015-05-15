%> @brief eClass-based feature selection
%>
%> @todo Temporarily deactivated
%>
%> Issue is similar to one wih LDA loadings: negative-positive-negative-positive-...
classdef as_fsel_eclass < as_fsel
    properties
        %> =10.
        nf_select = 10;
        %> =0.03.
        threshold = .03;
        type = 'fea';
    end;

    properties(SetAccess=protected)
        clssr = [];
        sgs = [];
        koeff = [];
    end;
            
    methods
        function o = as_fsel_eclass()
            o.classtitle = 'eClass';
            o.flag_params = 0;
            o.flag_ui = 0;
        end;
    end;
    
%     methods
%         function log = do_use(o, data)
%             idxsobs = sgs_get_obs_idxs(o.sgs, data);
%             no_reps = length(idxsobs.reps);
% 
%             X = data.X;
% 
%             koeff = zeros(size(X, 2)+1, 1);
% 
%             for i_rep = 1:no_reps
%                 fprintf('$*$*$*$ as_fsel_eclass session %d/%d. $*$*$*$\n', i_rep, no_reps);
% 
%                 idxstraintest = idxsobs.reps(i_rep).obs;
%                 d_train = data.map_rows(data, idxstraintest.train);
% 
%                 o.clssr = o.clssr.boot();
%                 o.clssr = o.clssr.train(d_train);
% 
%                 for i_rule = 1:o.clssr.no_rules
%                     koeff = koeff+sum(o.clssr.rulesets(o.clssr.rule_map(i_rule, 1)).rules(o.clssr.rule_map(i_rule, 2)).pi, 2);
%                 end;
%             end;
% 
%             % - Discards the bias
%             % - Makes it a row vector to be more consistent with usual disposition of variables as columns
%             % - Absolute value is taken because negative values are as important as positive ones
%             koeff = abs(koeff(2:end))';
% 
% 
%             % Now the feature selection
% 
%             if o.type == 'fea'
%                 [values, indexes] = sort(koeff, 'descend');
%                 o.v = sort(indexes(1:o.nf_select));
%             else
%                 indexes = 1:size(X, 2);
%                 o.v = indexes(koeff/sum(koeff) >= o.threshold);
%             end;
% 
%             o.koeff = koeff;
%         end;
%     end;
end
