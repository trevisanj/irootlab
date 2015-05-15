%> Feature subset grader - Fisher's Criterion
%>
%> @sa clssr_tree, fsgt
classdef fsgt_fisher < fsgt
    methods
        %> Original code for the Fisher's Criterion:
        %>
        %> Copyright R.P.W. Duin, duin@ph.tn.tudelft.nl
        %> Faculty of Applied Physics, Delft University of Technology
        %> P.O. Box 5046, 2600 GA Delft, The Netherlands
        function [grades, idx, threshold] = test(o, X, classes)
            X1 = X(classes == 0, :);
            X2 = X(classes == 1, :);

            % Between-; Within-
            m = (mean(X1, 1)-mean(X2, 1)).^2;
            s = std(X1, 0, 1).^2+std(X2, 0, 1).^2+realmin;

            grades = m./s; % Fisher's ratio
            [dummy, idx] = max(grades); % Best feature

            % Computes threshold
            m1 = mean(X1(:, idx), 1);
            m2 = mean(X2(:, idx), 1);
            w1 = m1-m2;
            if abs(w1) < eps
                % the means are equal, so the Fisher
                % criterion (should) become 0. Let us set the thresold
                % halfway the domain
                threshold = (max(X1(:, idx), [], 1) + min(X2(:, idx), [], 1))/2;
            else
                w2 = (m1*m1-m2*m2)/2;
                threshold = w2/w1;
            end;
        end;
    end;
    
    methods
        function o = fsgt_fisher(o)
            o.classtitle = 'Fisher''s Criterion';
        end;
    end;
end
