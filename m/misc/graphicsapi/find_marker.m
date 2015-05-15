%>@ingroup graphicsapi
%>@file
%>@brief Returns a marker for plotting
%
%> @param i
%> @return x
function x = find_marker(i)
fig_assert();
global MARKERS;
x = MARKERS(mod(i-1, size(MARKERS, 2))+1);
