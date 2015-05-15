%>@ingroup codegen idata
%>@file
%>@brief Returns a list of variables not to be brought from the workspace
%
function vars = get_excludevarnames()
vars = {'lo', 'blk', 'o', 'u', 'ans', 'out', 'TEMP'};