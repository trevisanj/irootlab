%> @brief Alters position of figure to make only the legend appear inside inner the figure area
%> @file
%> @ingroup graphicsapi
%>
%> This pretty much inutilizes the figure for other purpose than saving the legend as an image.
%>
%> @sa save_legend.m
%
function show_legend_only()
fig_assert();
global SCALE;
hl = legend();
psavel = get(hl, 'Position');

set(gca, 'position', [2.1, 0, 1.1, 0.1]); % Axis out of sight

set(hl, 'Position', [0, 0, psavel(3), psavel(4)]); % Moves legend maintaining position
set(hl, 'Units', 'pixels'); % Changes unit of legend handle in order to transfer position information from the legend to the figure
p = get(hl, 'Position');
set(hl, 'Position', [p(1)+SCALE+1, p(2)+SCALE+1, p(3), p(4)]); % Shifts a bit so that the whole border is visible
set(gcf, 'Position', [0, 0, p(3)+scaled(3), p(4)+scaled(3)]);
