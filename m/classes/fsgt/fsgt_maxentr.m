%> Maximum entropy split criterion for tree classifiers
%>
%> Reference:
%>
%> L. Breiman, J.H. Friedman, R.A. Olshen, and C.J. Stone, 
%> Classification and regression trees, Wadsworth, California, 1984. 
%>
%> @sa clssr_tree, fsgt
classdef fsgt_maxentr < fsgt
    methods
        %> Credits:
        %>
        %> Copyright: R.P.W. Duin, duin@ph.tn.tudelft.nl 
        %> Faculty of Applied Physics, Delft University of Technology
        %> P.O. Box 5046, 2600 GA Delft, The Netherlands
        function [grades, idx, threshold] = test(o, X, classes)
            [m,k] = size(X);
            c = max(classes);
            % -variable threshold is an (2c)x k matrix containing:
            %      minimum feature values class 1
            %      maximum feature values class 1
            %      minimum feature values class 2
            %      maximum feature values class 2
            %            etc.
            % -variable R (same size) contains:
            %      fraction of objects which is < min. class 1.
            %      fraction of objects which is > max. class 1.
            %      fraction of objects which is < min. class 2.
            %      fraction of objects which is > max. class 2.
            %            etc.
            % These values are collected and computed in the next loop:
            threshold = zeros(2*c,k); R = zeros(2*c,k);
            for j = 1:c
                L = (classes == j);
                if sum(L) == 0
                    threshold([2*j-1:2*j],:) = zeros(2,k);
                    R([2*j-1:2*j],:) = zeros(2,k);
                else
                    threshold(2*j-1,:) = min(X(L,:),[],1);
                    R(2*j-1,:) = sum(X < ones(m,1)*threshold(2*j-1,:),1);
                    threshold(2*j,:) = max(X(L,:),[],1);
                    R(2*j,:) = sum(X > ones(m,1)*threshold(2*j,:),1);
                end
            end
            % From R the purity index for all features is computed:
            G = R .* (m-R);
            % and the best feature is found:
            [gmax,tmax] = max(G,[],1);
            [grades,idx] = max(gmax);
            Tmax = tmax(idx);
            if Tmax ~= 2*floor(Tmax/2)
                threshold = (threshold(Tmax,idx) + max(X(find(X(:,idx) < threshold(Tmax,idx)),idx)))/2;
            else
                threshold = (threshold(Tmax,idx) + min(X(find(X(:,idx) > threshold(Tmax,idx)),idx)))/2;
            end
            if isempty(threshold)
                irerror('Maximum Entropy Criterion not feasible for this decision tree!');
            end;
        end;
    end;
    
    methods
        function o = fsgt_maxentr(o)
            o.classtitle = 'Maximum Entropy Criterion';
        end;
    end;
end
