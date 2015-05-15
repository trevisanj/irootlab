%> @brief Feature subset grader - t-test
%>
classdef fsg_test_t < fsg_test
    properties
        %> =1. If 1, result of test is -log10(p-value); if 0, result is p-value
        flag_logtake = 1;
    end;

    methods(Access=protected)
        function z = test(o, dd, idxs)
            z = zeros(1, numel(idxs));
            for i = 1:numel(idxs)
                X = dd(1).X(:, idxs{i});
                [dummy, z(i)] = ttest2(X(dd(1).classes == 0), X(dd(1).classes == 1), 0.05); % actually the third parameter (alpha) is irrelevant because we want the p-value only
            end;
            if o.flag_logtake
                z = -log10(z);
            end;
        end;
    end;
    
    methods
        function o = fsg_test_t()
            o.classtitle = 'T-Test';
            o.flag_pairwise = 1;
            o.flag_univariate = 1;
            o.flag_params = 1;
        end;
    end;
end
