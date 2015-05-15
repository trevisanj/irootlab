%>@ingroup datasettools
%> @file
%> @brief Selects data rows by giving group indexes as parameters
%>
%> <b>CAUTION: the indexes do not match the order in which the groups appear in the dataset. Instead, they are indexes to
%> unique(data.groupcodes)</b>
function out = data_select_groups(data, idxs_codes)

    idxs_obs = data.get_obsidxs_from_groupidxs(data, idxs_codes);
    out = data.split_map(data, {idxs_obs});

    
    % function is done. This part is verbose.
    codes = unique(data.groupcodes);
    str_codes = [];
    for i = 1:length(idxs_codes)
        if i > 1
            str_codes = [str_codes ', '];
        end;
        str_codes = [str_codes codes{idxs_codes(i)}];
    end;
    fprintf('INFO (data_select_groups()): codes selected: %s.\n', str_codes);
end;

