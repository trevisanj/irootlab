%> Biomarkers comparer class
%>
%> <h3>References</h3>
%> Trevisan et al 2012. Submitted to AC.
%>
%> @sa sigfun.m
classdef biocomparer < irobj
    properties
        %> =20. "half-height" distance between biomarkers. This is the distance in x-values (wavenumbers) where the degree of agreement
        %> will be considered to be 50%
        halfheight = 20;
        %> =1. Whether to use the weights that are passed to go()
        flag_use_weights = 1;
    end;

    methods
        %> @param A First set of wavenumbers
        %> @param B Second set of wavenumbers
        %> @param WA (Optional) Weights of first set of wavenumbers. If not supplied or supplied as "[]", all weights will be considered the same. The weight scale is irrelevant.
        %> @param WB (Optional) Weights of second set of wavenumbers. If not supplied or supplied as "[]", all weights will be considered the same. The weight scale is irrelevant.
        %> @return [matches, finalindex] the "matches" structure has the following fields:
        %>   @arg @c .indexes 2-element vector containing the indexes of the originals
        %>   @arg @c .wns 2-element vector containing the x-positions (wavenumbers/"wns") of the corresponding indexes
        %>   @arg @c .agreement Result of the agreement calculation using the sigmoit function
        %>   @arg @c .weight Average between the (normalized) weights of the matched positions
        %>   @arg @c .strength Just the result of <code>agreement*weight</code>
        %> The "agreement" will be calculated by a logistic sigmoid function (that of shape 1/(1+exp(x)))
        function [matches, finalindex] = go(o, A, B, WA, WB)

            % Parameters check and adjustments
            if nargin < 4 || isempty(WA) || ~o.flag_use_weights
                WA = ones(1, numel(A));
            end;
            if nargin < 5 || isempty(WB) || ~o.flag_use_weights
                WB = ones(1, numel(B));
            end;

            hh = o.halfheight;

            [m1, fi1] = o.internal_compare_biomarkers(A, B, WA, WB, hh);
            [m2, fi2] = o.internal_compare_biomarkers(B, A, WB, WA, hh);

            % Reverts the indexes and wns of second matches
            for i = 1:numel(m2)
                m2(i).indexes = m2(i).indexes([2, 1]);
                m2(i).wns = m2(i).wns([2, 1]);    
            end;


            matches = [m1, m2];
            finalindex = mean([fi1, fi2]);
        end;
    end;

    methods(Access=protected, Static)
        function [matches, finalindex] = internal_compare_biomarkers(A, B, WA, WB, hh)

            % Determines some sizes
            nA = length(A);
            nB = length(B);
            nmin = min([nA, nB]);
            nmax = max([nA, nB]);

%             sigfun0 = sigfun(0); % Small correction factor, because sigfun(0) = .9975 instead of 1

            for i = 1:nA
                % Finds element of B the closest to i-th element in A
                [val, idx0] = min(abs(A(i)-B));

                b.indexes = [i, idx0];
                b.wns = [A(i), B(idx0)];
                b.agreement = sigfun(val, hh); %/sigfun0;
                b.weight = mean([WA(i), WB(idx0)]);
            %     b.weight = sqrt(WA(i)*WB(idx0)); % Now geometric mean
                b.strength = b.agreement*b.weight;

                matches(i) = b; %#ok<AGROW>
            end;

            % Note that if n < nmax, some biomarkers will remain unmatched and the maximum final index will be n/nmax

            finalindex = sum([matches.strength])/sum([matches.weight]); % Normalizes to 1
%             finalindex = finalindex; *nA/nmax;
        end;
    end;
    
    methods
        function o = biocomparer()
            o.classtitle = 'Biomarkers comparer';
        end;
    end;
end
