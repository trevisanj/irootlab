%>@ingroup datasettools
%> @file
%> @brief Splits dataset according to class map.
%
%> @param data @c irdata object
%> @param maps Cell of vectors containing class indexes.
%>
%> @return <em>[pieces]</em> or <em>[pieces, map]</em>. @c pieces: array of irdata objects; @c map cell array of vectors containing the
%> indexes of the rows in the original dataset that went to each element of piece.
function varargout = data_split_classmap(data, maps)
if ~exist('hierarchy', 'var')
    hierarchy = []; % means maximum possible
end;

if ~iscell(maps)
    maps = {maps};
end;

obsmaps = classmap2obsmap(maps, data.classes);
out = data.split_map(obsmaps);

if nargout == 1
    varargout = {out};
else
    varargout = {out, obsmaps};
end;
