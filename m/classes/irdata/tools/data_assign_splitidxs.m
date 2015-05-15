%>@ingroup datasettools
%> @file
%> @brief Assigns the splitidxs property based on hierarchy
%>
%> Similar to @ref data_split_classes.m, but does not mess with irdata::classes, does with irdata::splitidxs instead
%> @sa @ref irdata
function data = data_assign_splitidxs(data, hierarchy)
if ~exist('hierarchy', 'var')
    hierarchy = [];
end;
comoassim = classlabels2cell(data.classlabels, hierarchy);
map = cell2mat(comoassim(:, 4));
data.splitidxs = map(data.classes+1);
