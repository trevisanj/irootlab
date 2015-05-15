%> @ingroup ioio string
%> @file
%> @brief Auxiliar to @ref mergetool.m
function [filenames, groupcodes] = resolve_dir(wild, trimdot, flag_image)
a = dir(wild);
n = numel(a);
i = 0;
groupcodes = {};
filenames = {};
orderref = [];

% Resolves group code
for k = 1:n
    if ~a(k).isdir
        i = i+1;
        filenames{i} = a(k).name;
        idxs = find([filenames{i}, '.'] == '.');
        if isempty(idxs)
            code = filenames{i};
        else
            idx_idx_trim = max(1, length(idxs)-trimdot);
            code = filenames{i}(1:idxs(idx_idx_trim)-1);
        end;
        groupcodes{i} = code;

        if flag_image
            if trimdot < 1
                irerror('Trimdot < 1 does not allow for file order extraction!');
            elseif isempty(idxs)
                irerror('No dots in filename!');
            end;
            try
                orderref(i) = eval(filenames{i}(idxs(idx_idx_trim)+1:idxs(idx_idx_trim+1)-1));
            catch ME %#ok<NASGU>
                irerror('Error trying to find a sequential number across the filenames!');
            end;
        end;
    end;
end;

if flag_image
    [vv, ii] = sort(orderref);
    filenames = filenames(ii);
    groupcodes = groupcodes(ii);
end;
