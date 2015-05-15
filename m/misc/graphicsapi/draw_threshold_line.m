%>@ingroup graphicsapi
%> @file
%> @brief Draws threshold line
%
%> @param x x-axis values
%> @param y scalar
%> @param width =2
%> @param color =[.7,0,0]
function draw_threshold_line(x, y, width, color)
global SCALE;
if ~exist('width', 'var') || isempty(width)
    width = scaled(2);
end;
if ~exist('color', 'var') || isempty(color)
    color = [.7, 0, 0];
end;

len = length(x);
z = ones(1, len)*y;
plot(x, z, 'LineStyle', '--', 'LineWidth', width, 'Color', color);
