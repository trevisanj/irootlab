%>@ingroup graphicsapi
%>@file
%>@brief Enlightens all colors in the COLORS global
%
%> @param factor=1.5 Multiplier
function enlighten_colors(factor)

if nargin < 1 || isempty(factor)
    factor = 1.5;
end;

fig_assert();
global COLORS;
COLORS = cellfun(@(x) iif(any(x > 1), min(x*factor, 255), min(x*1.45, 1)), COLORS, 'UniformOutput', 0);