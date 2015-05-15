%>@ingroup graphicsapi
%>@file
%>@brief Returns a line style
%
%> @param i
%> @return x
function x = find_linestyle(i)
fig_assert();
global LINESTYLES;
x = LINESTYLES{mod(i-1, length(LINESTYLES))+1};

