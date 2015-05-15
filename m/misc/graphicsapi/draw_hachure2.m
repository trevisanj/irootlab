%>@ingroup graphicsapi idata
%> @file
%> @brief Draws hachure
%>
%> This hachure typically represents confidence intervals, prediction intervals, or standard deviations.
%>
%> The hachures interfere with the line width of the axes and legend border - weird but this is a MATLAB's problem
%
%> @param xaxis
%> @param intervals must be a [2]x[number of points] vector with one interval in each column, where the first element is the lower value
%> @param color
function draw_hachure2(xaxis, intervals, color)


% Some tolerance in the shape of the inputs
xaxis = xaxis(:)'; % Makes sure xaxis is a row vector


if size(intervals, 1) ~= 2
    irerror('"intervals" must be a 2-row vector!');
end;

if intervals(1, 1) > intervals(2, 1)
    irerror('First row of "intervals" must contain the lower values!');
end;

xx = [xaxis, xaxis(end:-1:1)];
yy = [intervals(1, :), intervals(2, end:-1:1)];
fill(xx, yy, color, 'LineStyle', '-', 'FaceAlpha', 0.25, 'EdgeColor', color, 'LineWidth', scaled(1), 'EdgeAlpha', 0.8);
