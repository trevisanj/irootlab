%> Feature subset grader - Fisher's score: between-class variance divided by within-class variance
%>
%> <h3>Reference</h3>
%> Duda et al 2001, Pattern Classification
classdef fsg_test_fisher < fsg_test
    methods(Access=protected)
        function z = test(o, dd, idxs)
            z = zeros(1, numel(idxs));
            for i = 1:numel(idxs)
                if numel(idxs{i}) > 1
                    irerror('This is a univariate test!');
                end;
                
                [s_b, s_w] = calculate_scatters(dd(1).X(:, idxs{i}), dd(1).classes);
                
                z(i) = s_b/(s_w+realmin);
            end;
        end;
    end;
    
    methods
        function o = fsg_test_fisher(o)
            o.classtitle = 'Fisher''s score';
            o.flag_pairwise = 0;
            o.flag_univariate = 1;
            o.flag_params = 0;
        end;
    end;
end
