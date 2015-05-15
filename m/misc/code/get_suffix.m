%>@ingroup codegen string
%> @file
%> @brief Finds a suffix based on the class name. Isolates the bit after the last undescore
%> @todo Could respond to IRootLab setup to change the way new generated objects are named, i.e. how they appear in objtool and datatool
%
%> @param clname Class name.
%> @param no_trim
function suffix = get_suffix(clname, no_trim)
if ~exist('no_trim', 'var') || isempty(no_trim)
    no_trim = 1;
end;
pos = strfind(clname, '_');
if isempty(pos)
    suffix = clname;
else
    pospos = numel(pos)-no_trim+1;
    if pospos > numel(pos)
        i1 = numel(clname)+1;
    elseif pospos < 0
        i1 = 1;
    else
        i1 = pos(pospos)+1;
    end;
    suffix = clname(i1:end);
end;
