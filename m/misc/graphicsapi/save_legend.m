%>@brief Saves current legend as PNG
%>@file
%>@ingroup graphicsapi ioio
%>
%> This function will save a PNG with the legend, but will mess with the positioning on the screen
%>
%> @attention May not work well if the window is maximized
%>
%> @sa show_legend_only.m
%
%> @param fn =(new) File name
%> @param dpi =0 Dots Per Inch = resolution. 0 = screen resolution
%> @return File name
function fn = save_legend(fn, dpi)
fig_assert();

if nargin < 1 || isempty(fn)
    fn = find_filename('irr_legend', [], 'png');
end;
if nargin < 2 || isempty(dpi)
    dpi = 0;
end;

psavef = get(gcf, 'Position');
psavea = get(gca, 'Position');

hl = legend();
psavel = get(hl, 'Position');
usavel = get(hl, 'Units');

show_legend_only();

save_as_png(gcf(), fn, dpi);

% Restoration
set(hl, 'Units', usavel);
set(hl, 'Position', psavel);

set(gca, 'Position', psavea);
set(gcf, 'Position', psavef);


