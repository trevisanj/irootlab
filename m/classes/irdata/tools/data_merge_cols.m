%>@ingroup datasettools
%> @file
%> @brief Merges several datasets into one (column-wise)
%>
%> The new dataset ('out') will be first created as a clone of datasets(1), then column subsequently added to X, fea_x and fea_names
%>
%> Needless say the datasets need to be row-compatible.
%>
%> Classes, group_codes, classlabels etc are not checked for comptatibility. Assumes responsible use by the user.

function out = data_merge_cols(datasets)

% prepares a clone, except for the fields in rowfieldnames
out = datasets(1);
for j = 2:numel(datasets)
    if out.no ~= datasets(j).no
        irerror(sprintf('Dataset %d has number of rows different of dataset 1!', j));
    end;
    out.X = [out.X datasets(j).X];
    out.fea_x = [out.fea_x datasets(j).fea_x];
    out.fea_names = [out.fea_names datasets(j).fea_names];
end;


