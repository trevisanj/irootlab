%>@ingroup datasettools
%> @file
%> @brief Selects only the data rows whose class is >= 0
%>
%> @param data
function data = data_select_inliers(data)
b_out = data.classes < 0;
for i = 1:numel(data.rowfieldnames)
    if ~isempty(data.(data.rowfieldnames{i}))
        data.(data.rowfieldnames{i})(b_out, :) = [];
    end;
end;
