%>@ingroup maths
%> @file
%> @brief Calculates the stability curve for a set of feature subsets
%>
%> This function is suitable for feature subsets found using Sequential Forward Feature Selection
%>
%> Kuncheva's "consistency" formula is I_c = (r-k^2/nf)/(k-k^2/nf), where r is the number of common elements in the two sets, and k is the 
%> number of elements of either sets
%>
%>
%> <h3>References</h3>
%>
%> ﻿Kuncheva, L. I. A stability index for feature selection, 390-395.
%>
%> @param subsets matrix or cell of subsets. If matrix, each row is a subset. A subset contains feature indexes. If cell of subsets, all
%>                subsets must have the same number of elements
%> @param nf Number of features
%> @param type ='kun'. Type of stability measuse. Possibilities are:
%>   @arg 'kun' Kuncheva's Stability Index
%>   @arg ... (open for others)
%> @param type2='mul'
%>   @arg 'uni' evaluates position in subsets individually
%>   @arg 'mul' evaluates considering m-sized subsets (m = 1..k)

%> @return y nf x stability curve
function y = featurestability(subsets, nf, type, type2)

if nargin < 3 || isempty(type)
    type = 'kun';
end;

if nargin < 4 || isempty(type2)
    type2 = 'mul';
end;
flag_uni = strcmp(type2, 'uni');

%> translates type into a function handle
switch type
    case 'kun'
        f_type = @feacons_kun;
    otherwise
        irerror(sprintf('Feature consistency type "%s" not implemented', type));
end;

% if cell, converts to matrix
if iscell(subsets)
    subsets = subsets2matrix(subsets);
end;

[nsub, k] = size(subsets);

y = zeros(1, k);
for m = 1:k
    if flag_uni
        temp = subsets(:, m);
    else
        temp = subsets(:, 1:m);
    end;
    for i = 1:nsub
        for j = i+1:nsub
            y(m) = y(m)+f_type(temp(i, :), temp(j, :), nf);
        end;
    end;
end;
y = y*2/(nsub*(nsub-1)); % takes the average consistency
