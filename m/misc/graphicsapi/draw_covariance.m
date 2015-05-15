%>@ingroup graphicsapi
%> @file
%> @brief Draws covariance matrix
%>
%> @sa data_draw_covariance.m
%
%> @param C
%> @param x
%> @param y
function draw_covariance(C, x, y)
global SCALE;

nf = size(C, 1);

if ~exist('x', 'var')
    x = 1:nf;
end;


if ~exist('y', 'var')
  y = [];
end;


[XX, YY] = meshgrid(x, x);

x1 = x(1);
x2 = x(end);
xmin = min(x1, x2);
xmax = max(x1, x2);
xrange = xmax-xmin;
flag_reverse = x1 > x2;

% pcolor(XX, YY, C);
imagesc(x([1, end]), x([1, end]), C);
axis image;
shading interp;
hold on;
% contour(XX, YY, C, 4, 'LineWidth', 20, 'Color', 'k');

if ~isempty(y)
    y = (y-min(y))/(max(y)-min(y)); %shift-scale
    k = 100; % scaling for reference spectrum
    z = .1*ones(1, length(x));
    colour = 'k'; %[.5, .5, .5];
    width = scaled(3);
    plot3(x, x2-y*k, z, 'Color', colour, 'LineWidth', width);
    plot3(x2-y*k, x, z, 'Color', colour, 'LineWidth', width);
else
    k = 0;
end;

% plot3([x2, x2, x1, x1, x2], [x1, x2, x2, x1, x1], [.1, .1, .1, .1, .1], 'k', 'LineWidth', scaled(2));


set(gca, 'XLim', [xmin-xrange*.02-k, xmax+xrange*.02]);
set(gca, 'YLim', [xmin-xrange*.02-k, xmax+xrange*.02]);
xlabel('Wavenumber (cm^{-1})');
ylabel('Wavenumber (cm^{-1})');
if flag_reverse
    set(gca, 'XDir', 'reverse');
    set(gca, 'YDir', 'reverse');
end;
%     set(gca, 'XTick', [1210, 1645]);
%     set(gca, 'YTick', [1210, 1645]);
box off;

format_frank(gcf, 1);

