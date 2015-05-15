%> Information Gain split criterion for tree classifiers
%>
%> @sa clssr_tree, fsgt
classdef fsgt_infgain < fsgt
    methods
        %> Credit:
        %>
        %> Copyright: R.P.W. Duin, duin@ph.tn.tudelft.nl
        %> Faculty of Applied Physics, Delft University of Technology
        %> P.O. Box 5046, 2600 GA Delft, The Netherlands
        function [grades, idx, threshold] = test(o, X, classes)
            [m,k] = size(X);
            classes = classes+1;
            c = max(classes);
            mininfo = ones(k,2);
            % determine feature domains of interest
            [sn,ln] = min(X,[],1); 
            [sx,lx] = max(X,[],1);
            JN = (classes(:,ones(1,k)) == ones(m,1)*classes(ln)') * realmax;
            JX = -(classes(:,ones(1,k)) == ones(m,1)*classes(lx)') * realmax;
            S = sort([sn; min(X+JN,[],1); max(X+JX,[],1); sx]);
            % S(2,:) to S(3,:) are interesting feature domains
            P = sort(X);
            Q = (P >= ones(m,1)*S(2,:)) & (P <= ones(m,1)*S(3,:));
            % these are the feature values in those domains
            for f=1:k,		% repeat for all features
                af = X(:,f);
                JQ = find(Q(:,f));
                SET = P(JQ,f)';
                if JQ(1) ~= 1
                    SET = [P(JQ(1)-1,f), SET];
                end
                n = length(JQ);
                if JQ(n) ~= m
                    SET = [SET, P(JQ(n)+1,f)];
                end
                n = length(SET) -1;
                T = (SET(1:n) + SET(2:n+1))/2; % all possible thresholds
                L = zeros(c,n); R = L;     % left and right node object counts per class
                for j = 1:c
                    J = find(classes==j); mj = length(J);
                    if mj == 0
                        L(j,:) = realmin*ones(1,n); R(j,:) = L(j,:);
                    else
                        L(j,:) = sum(repmat(af(J),1,n) <= repmat(T,mj,1)) + realmin;
                        R(j,:) = sum(repmat(af(J),1,n) > repmat(T,mj,1)) + realmin;
                    end
                end
                infomeas =  - (sum(L .* log10(L./(ones(c,1)*sum(L)))) ...
                           + sum(R .* log10(R./(ones(c,1)*sum(R))))) ...
                    ./ (log10(2)*(sum(L)+sum(R))); % criterion value for all thresholds
                [mininfo(f,1),j] = min(infomeas);     % finds the best
                mininfo(f,2) = T(j);     % and its threshold
            end   
            grades = 1-mininfo(:,1)';
            [finfo,idx] = min(mininfo(:,1));		% best over all features
            threshold = mininfo(idx,2);			% and its threshold
        end;
    end;
    
    methods
        function o = fsgt_infgain(o)
            o.classtitle = 'Information Gain Criterion';
        end;
    end;
end
