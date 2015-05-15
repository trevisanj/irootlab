%>@ingroup datasettools
%> @file
%> @brief Sorts data.classlabels and renumbers data.classes accordingly
function data = data_sort_classlabels(data)

no_classes = length(data.classlabels);
[data.classlabels, indexes0] = sort(data.classlabels);

indexes_new = zeros(1, no_classes);
for i = 1:no_classes
    indexes_new(i) = find(indexes0 == i);
end;

for i = 1:data.no
    data.classes(i) = indexes_new(data.classes(i)+1)-1;
end;

