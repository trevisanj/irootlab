%>@ingroup datasettools classlabelsgroup
%> @file
%> @brief Selects certain levels within the class labels
%>
%> This function keeps selected class levels and renumbers classes accordingly.
%>
%> @sa @ref irdata for reference on multi-level class label
%
%> @param data
%> @param hierarchy =[]. 0 means "none"; [] means "all"

function data = data_select_hierarchy(data, hierarchy)
if ~exist('hierarchy', 'var')
    hierarchy = [];
end;
cc = classlabels2cell(data.classlabels, hierarchy);

data.classlabels = cell2classlabels(cc);  % Conversion back to class labels eliminates all redundancies whilst keeping the order of appearance
for i = 1:size(cc, 1)
    data.classes(data.classes == i-1) = cc{i, 4};  % Renumbering to respect new class labels.
end;
