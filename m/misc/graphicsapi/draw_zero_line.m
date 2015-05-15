%>@ingroup graphicsapi
%>@file
%>@brief Draws zero line
%
%> @param x = xlim()
%> @param linewidth
function draw_zero_line(x, linewidth)

if nargin < 1 || isempty(x)
    x = xlim();
end;
if numel(x) < 2
    x = [x-1, x+1];
else
    x = x([1, end]);
end;

if ~exist('linewidth', 'var')
    linewidth = scaled(2);
end;

len = length(x);
z = zeros(1, len);
plot(x, z, 'Color', [0, 0, 0], 'LineWidth', linewidth);
