%>@ingroup datasettools
%> @file
%> @brief Renumbers classes to match the class order of a reference dataset
%>
%> @param ds_ori Origin dataset, dataset to be changed
%> @param ref Reference dataset / reference classlabels
%> @param Return Origin dataset with its classes and classlabels reordered
%>
%> @sa renumber_classes.m
function ds_ori = data_renumber_classes(ds_ori, ref)

if isa(ref, 'irdata')
    ref = ref.classlabels;
end;

ds_ori.classes = renumber_classes(ds_ori.classes, ds_ori.classlabels, ref);
ds_ori.classlabels = ref;
