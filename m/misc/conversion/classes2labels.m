%> @ingroup conversion classlabelsgroup
%> @file
%> @brief Converts classes to labels
%
%> @param classes Classes
%> @param labels List of class labels
%> @return A Cell of strings of same dimensions of @c classes
function out = classes2labels(classes, labels)

no_obs = length(classes);
out = cell(no_obs, 1);
for i = 1:no_obs
    out{i} = labels{classes(i)+1};
end;

