%> @brief Feature subset grader - Mann-Whitney "U"-test
%>
classdef fsg_test_u < fsg_test
    properties
        %> Whether to make result as -log10(p_value)
        flag_logtake = 1;
    end;

    methods(Access=protected)
        function z = test(o, dd, idxs)
            z = zeros(1, numel(idxs));
            for i = 1:numel(idxs)
                X = dd(1).X(:, idxs{i});
                z(i) = ranksum(X(dd(1).classes == 0), X(dd(1).classes == 1));
            end;
            if o.flag_logtake
                z = -log10(z);
            end;
        end;
    end;
    
    methods
        function o = fsg_test_u(o)
            o.classtitle = 'U-Test';
            o.flag_pairwise = 1;
            o.flag_univariate = 1;
            o.flag_params = 1;
        end;
    end;
end
