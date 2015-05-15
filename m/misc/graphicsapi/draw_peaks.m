%>@ingroup graphicsapi
%> @file
%> @brief Draws peaks
%
%> @param x
%> @param y
%> @param indexes
%> @param flag_text
%> @param color =black
%> @param marker =x
%< @param markersize =scaled(10)
function draw_peaks(x, y, indexes, flag_text, color, marker, markersize)
fig_assert();
global FONTSIZE FONT;

if ~exist('flag_text', 'var')
    flag_text = 1;
end;
if nargin < 5 || isempty(color)
    color = [0, 0, 0];
end;
if nargin < 6 || isempty(marker)
    marker = 'x';
end;
if nargin < 7 || isempty(markersize)
    markersize = scaled(10);
end;

scale = max(abs(y));
% offset = 0.025*scale;

y(y == Inf) = max(y(y ~= Inf));

x_peaks = x(indexes);
y_peaks = y(indexes);


for i = 1:length(x_peaks)
    plot(x_peaks(i), y_peaks(i), 'Color', color, 'Marker', marker, 'MarkerSize', markersize, 'LineWidth', scaled(3));
    hold on;
    offset = 0.025*scale;
    if y_peaks(i) < 0
        offset = -offset;
    end;
    
    if flag_text
        text(x_peaks(i), y_peaks(i)+offset, sprintf('%.0f', x(indexes(i))), 'FontName', FONT, 'FontSize', FONTSIZE*scaled(0.75));
    end;
end;
