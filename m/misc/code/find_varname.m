%>@ingroup codegen
%> @file
%> @brief Finds an unused variable name in the workspace
%
%> @param prefix
%> @return name_new
function name_new = find_varname(prefix)
i = 1;
while 1
    name_new = sprintf('%s%02d', prefix, i);
	if length(name_new) > 63
        irerror(sprintf('Variable name ''%s'' is too big to add suffixes to it! Try renaming first.', prefix));
    end;
    if ~evalin('base', sprintf('exist(''%s'', ''var'')', name_new))
        break;
    end;
    i = i+1;
end;
