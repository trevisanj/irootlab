%>@ingroup datasettools
%> @file
%> @brief Sorts dataset rows by groupcode
function varargout = data_sort_by_group(data)

    [vals, idxs] = sortrows(data.groupcodes);

    data = data_map_rows(data, idxs);

    if nargout == 2
        varargout = {data, idxs};
    else
        varargout = {data};
    end;
end;

