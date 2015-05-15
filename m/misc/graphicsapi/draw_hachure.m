%>@ingroup graphicsapi idata
%>@file
%>@brief Draws hachure
%
%> @param position a MATLAB-like "position" vector: [x, y, width, height]
function draw_hachure(position)
rectangle('Position', position, 'LineStyle', 'none', 'FaceColor', [1, 1, 1]*.75);
