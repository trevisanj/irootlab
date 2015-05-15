%> @ingroup conversion classlabelsgroup
%> @file
%> @brief Compares two classes vectors given their corresponding class labels
%
%> @param classes1
%> @param labels1
%> @param classes2
%> @param labels2
%> @return Boolean vector
function result = compare_classes(classes1, labels1, classes2, labels2)

no_obs = length(classes1);
a1 = cell(1, no_obs);
a2 = cell(1, no_obs);
for i = 1:no_obs
    a1{i} = labels1{classes1(i)+1};
    a2{i} = labels2{classes2(i)+1};
end;

result = strcmp(a1, a2);

