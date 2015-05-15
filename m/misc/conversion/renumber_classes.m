%> @ingroup conversion classlabelsgroup
%> @file
%> @brief Renumbers classes to match a new set of labels
%>
%> The new set of labels is represented by the @c classlabels_ref parameter. If a class label from the @c classlabels_orig is not found in 
%> @c classlabels_ref, its corresponding data rows will be assigned to class @c -2.
%
%> @param classes_orig
%> @param classlabels_orig Needs to be a subset of @c classlabels_ref
%> @param classlabels_ref
%> @return classes
function classes = renumber_classes(classes_orig, classlabels_orig, classlabels_ref)
classes = classes_orig;
if isempty(classes)
    irverbose('WARNING: ''classes_orig'' parameter is empty''', 1);
end;
for i = 1:numel(classlabels_orig)
    newclass = find(strcmp(classlabels_orig{i}, classlabels_ref))-1;
    if isempty(newclass)
        newclass = -2;
%         irerror(sprintf('Class "%s" not found in reference class labels', classlabels_orig{i}));
    end;
    classes(classes_orig == i-1) = newclass;
end;
