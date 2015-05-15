%> @file
%> @brief Generates unique class labels in order of appearance
%> @ingroup maths classlabelsgroup
%
%> @param classlabels
%> @return ucl Unique class labels
function ucl = unique_appear(classlabels)

[templabels, idxs] = unique(classlabels, 'first');
[dummy, idxs2] = sort(idxs);  % Preserves original class order as much as possible. Sorts indexes of first occurence...
ucl = templabels(idxs2); % and reorders new class labels so that first to appear will also appear first now.
