%>@ingroup graphicsapi
%> @file
%> @brief Draws hachure to above and below a curve
%>
%> This function uses a single "stds" vector to represent the upper and lower vertical distances from the "curve".
%>
%> It calls @ref draw_hachure2.m to do the job
%>
%
%> @param xaxis
%> @param curve
%> @param stds
%> @param color
function draw_stdhachure(xaxis, curve, stds, color)

% Makes sure that everything is a row vector
xaxis = xaxis(:)';
curve = curve(:)';
stds = stds(:)';

intervals = [curve-stds; curve+stds];

draw_hachure2(xaxis, intervals, color);
