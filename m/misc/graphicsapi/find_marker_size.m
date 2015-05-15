%>@ingroup graphicsapi
%>@file
%>@brief Returns a marker size already scaled by the @c SCALE global.
%
%> @param i
%> @return x
function x = find_marker_size(i)
fig_assert();
global MARKERSIZES SCALE;
x = MARKERSIZES(mod(i-1, size(MARKERSIZES, 2))+1)*SCALE;
