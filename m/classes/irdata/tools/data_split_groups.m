%> @ingroup datasettools
%> @file
%> @brief Splits data according to groups. Returns an array of datasets.
%>

%> @param data irdata object
%>
%> @return <em>[pieces]</em> or <em>[pieces, map]</em>. @c pieces: array of irdata objects; @c map cell array of vectors containing the
%> indexes of the rows in the original dataset that went to each element of piece.
function varargout = data_split_groups(data)

if isempty(data.groupcodes)
    irerror('Dataset groupcodes is empty, cannot split dataset based on groups!');
end;

for i = data.no_groups:-1:1  % Backwards to allocate at once
    obsmaps{i} = data.get_obsidxs_from_groupidxs(i);
end;
out = data.split_map(obsmaps);

if nargout == 1
    varargout = {out};
else
    varargout = {out, obsmaps};
end;
