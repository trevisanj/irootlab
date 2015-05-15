%> @brief Feature subset grader - MANOVA
%>
classdef fsg_test_manova < fsg_test
    properties
        %> Whether to make result as -log10(p_value)
        flag_logtake = 1;
    end;

    methods(Access=protected)
        function z = test(o, dd, idxs)
            z = zeros(1, numel(idxs));
            for i = 1:numel(idxs)
                X = dd(1).X(:, idxs{i});
                [dummy, pp] = manova1(X, dd(1).classes);
                z(i) = pp(1);
            end;
            if o.flag_logtake
                z = -log10(z);
            end;
        end;
    end;
    
    methods
        function o = fsg_test_manova(o)
            o.classtitle = 'MANOVA';
            o.flag_pairwise = 0;
            o.flag_univariate = 0;
            o.flag_params = 1;
        end;
    end;
end
