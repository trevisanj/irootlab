%> @ingroup conversion classlabelsgroup
%>@file
%>@brief Makes legend cell based on existing classes and class labels
%
%> @param Y classes vector
%> @param classlabels Class labels
%> @return A cell containing the legend strings
function legends = classes2legends(Y, classlabels)

if nargin < 2 || isempty(classlabels)
    classlabels = cell(1, max(Y)+1);
    for i = 1:max(Y)+1
        classlabels{i} = ['Class ', int2str(i-1)];
    end;
end;

uy = unique(Y);
uy1 = uy(uy < 0);
nuy1 = numel(uy1);
clneg = cell(1, nuy1);
for i = 1:nuy1
    clneg{i} = get_negative_meaning(uy1(i));
end;

legends = [clneg, classlabels{unique(Y(Y >= 0))+1}];

