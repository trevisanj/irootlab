%> @brief Feature subset grader - ANOVA
%>
classdef fsg_test_anova < fsg_test
    properties
        %> Whether to make result as -log10(p_value)
        flag_logtake = 1;
    end;

    methods(Access=protected)
        function z = test(o, dd, idxs)
            % actually the third parameter (alpha) is irrelevant because we want the p-value only
            z = zeros(1, numel(idxs));
            for i = 1:numel(idxs)
                X = dd(1).X(:, idxs{i});
                z(i) = anova1(X, dd(1).classes, 'off');
            end;
            if o.flag_logtake
                z = -log10(z);
            end;
        end;
    end;
    
    methods
        function o = fsg_test_anova(o)
            o.classtitle = 'ANOVA';
            o.flag_pairwise = 0;
            o.flag_univariate = 1;
            o.flag_params = 1;
        end;
    end;
end
