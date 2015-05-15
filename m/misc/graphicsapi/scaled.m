%>@ingroup graphicsapi
%>@file
%>@brief Multiplies by the SCALE global
%
%> @param i
%> @return x
function x = scaled(i)
fig_assert();
global SCALE;
x = i*SCALE;


