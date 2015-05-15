%>@ingroup datasettools
%> @file
%> @brief Splits data using SGS. Returns an array of structures.
%>
%> Utilizes the maps issued by the @ref sgs object as row maps to split the dataset

%> @param data @ref irdata object
%> @param sgs @ref sgs object
%>
%> @return <em>[pieces]</em> or <em>[pieces, map]</em>. @c pieces: array of irdata objects; @c map cell array of vectors containing the
%> indexes of the rows in the original dataset that went to each element of piece.
function varargout = data_split_sgs(data, sgs)

obsmaps = sgs.get_obsidxs(data);

out = data.split_map(obsmaps);

if nargout == 1
    varargout = {out};
else
    varargout = {out, obsmaps};
end;
