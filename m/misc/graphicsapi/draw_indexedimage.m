%>@ingroup graphicsapi
%> @file
%> @brief Draws indexed image map
%
%> @param Y vector with integer values
%> @param height
%> @param classlabels
%> @param direction='ver' Same as irdata.direction
function draw_indexedimage(Y, height, direction, classlabels)

width = numel(Y)/height;
if width ~= floor(width)
    irerror(sprintf('Invalid height: number of image points not divisible by specified height: %d', height));
end;

if nargin < 3 || isempty(direction)
    direction = 'ver';
end;
if nargin < 4 || isempty(classlabels)
    classlabels = [];
end;


legends = classes2legends(Y, classlabels);

cm = classes2colormap(Y);
cm2 = classes2colormap(Y, 1);


uy = unique(Y);
for i = 1:numel(uy)
    h(i) = plot(-1, 0, 's', 'Color', cm2(i, :), 'MarkerSize', 20, 'MarkerFaceColor', cm2(i, :));
    hold on;
end;

legend(h, legends);


if strcmp(direction, 'hor')
    M = reshape(Y, width, height)';
else
    M = reshape(Y, height, width);
end;
imagesc(M);

colormap(cm);


shading flat;

axis image;
axis off;
set(gca, 'XDir', 'normal', 'YDir', 'normal');
set(gca, 'XLim', [1, width], 'YLim', [1, height]);
format_frank();
