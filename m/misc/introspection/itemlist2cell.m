%> @file
%> @ingroup introspection conversion
%> @brief Returns an array of mapitem objects matching the informed criteria.
%
%> @brief Converts an array of mapitem objects to a cell of indented strings.
%> @param list Array of mapitem objects
%> @param verboselevel = 3. Enters debug mode at verboselevel <= 2
%> @param style = 0. 0-style for blockmenu; 1-suitable for documents
%> @retval cc Cell of strings
function dd = itemlist2cell(list, verboselevel, style)

NINDENT = 2;

if ~exist('verboselevel', 'var')
    verboselevel = 0;
end;
if ~exist('style', 'var')
    style = 0;
end;
n = length(list);
if style == 0
    if verboselevel <= 2 % Debug
        nc = 3;
    else
        nc = 2;
    end;
elseif style == 1
    nc = 3;
else
    irerror(sprintt('Invalid style: %d', style));
end;
cc = cell(n, nc);
for i = 1:n
    if list(i).flag_final
        sep1 = ''; sep2 = '';
        c1 = '.';
        sp = 32;
    else
        sep1 = ''; sep2 = '';
        c1 = '+';
        if style == 0
            sp = '-';
        elseif style == 1
            sp = ' ';
        end;
    end;
    spaces = char(sp*ones(1, NINDENT*(list(i).level-1)));

    if style == 0
        if verboselevel <= 2 % Debug
            cc(i, :) = {c1, ...
                        [spaces, sep1, list(i).title, sep2], ...
                        [' ::', list(i).name, '::']};

        else
            cc(i, :) = {c1, ...
                        [spaces, sep1, list(i).title, sep2]};
        end;
    elseif style == 1
        cc(i, :) = {c1, ...
                    [spaces, list(i).name], ...
                    [spaces, list(i).title]};
    end;
        
end;

if style == 0
    for i = 1:nc
        cols{i} = char(cc(:, i));
    end;
    dd = cellstr(cat(2, cols{:}));
elseif style == 1
    dd = cc;
end;
    
% dd = sort(dd);
