%>@ingroup graphicsapi
%>@file
%>@brief Draws hint curve
%>
%> Default color is black and default line style is dashed. Default line width is <code>scaled(1)</code>.
%
%> @param x
%> @param y
%> @param color
%> @return o Handle returned by plot()
function o = draw_hint_curve(x, y, color)
fig_assert();
global SCALE;

if ~exist('color', 'var')
    color = 'k--';
end;
o = plot(x, y, color, 'LineWidth', scaled(1));

