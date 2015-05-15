%>@ingroup maths
%> @file
%> @brief Estimates the univariate distribution of a data vector.
%>
%> Uses a "Gaussian lump" aka kernel to estimate the distribution of a data vector.
%>
%> The lump aka kernel centered at each x(i) is given by the formula exp(-(xa-x(i)).^2/(2*wid^2)) .
%
%> @param x Data vector
%> @param no_points=100 Number of points in outputs. Similar to number of bins of a histogram. It is the resolution of the outputs.
%> @param range=(autocalculated) Initial and final x-axis points
%> @param wid=str(x)/sqrt(10) "Lump" width
%> @return [xa, ya]
function [xa, ya] = distribution(x, no_points, range, wid)

if ~exist('no_points', 'var') || isempty(no_points)
    no_points = 100;
end;

if ~exist('range', 'var') || isempty(range)
    k = 0;
    extent = max(x)-min(x);
    range = [min(x)-extent*k, max(x)+extent*k];
end;

if ~exist('wid', 'var') || isempty(wid)
    wid = std(x)/sqrt(10);  % lump width
end;

xa = linspace(range(1), range(2), no_points);
ya = zeros(1, no_points);

for i = 1:length(x)
    ya = ya+exp(-(xa-x(i)).^2/(2*wid^2));
%     if any(isnan(ya))
%         keyboard;
%     end;
end;

delta_x = xa(2)-xa(1);
ya = ya/(sum(ya)*delta_x);  % sum is rough integration 

