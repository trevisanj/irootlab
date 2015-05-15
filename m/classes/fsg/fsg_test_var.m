%> @brief Feature subset grader - variance
classdef fsg_test_var < fsg_test
    methods(Access=protected)
        function z = test(o, dd, idxs)
            z = zeros(1, numel(idxs));
            for i = 1:numel(idxs)
                X = dd(1).X(:, idxs{i});
                z(i) = mean(var(X, [], 1));
            end;
        end;
    end;
    
    methods
        function o = fsg_test_var(o)
            o.classtitle = 'Variance';
            o.flag_pairwise = 0;
            o.flag_univariate = 1;
            o.flag_params = 0;
        end;
    end;
end
