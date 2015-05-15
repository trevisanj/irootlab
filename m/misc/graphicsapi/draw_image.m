%>@ingroup graphicsapi
%> @file
%> @brief Draws image map
%
%> @param Y
%> @param height
%> @param direction='ver' Same as irdata.direction
function draw_image(Y, height, direction)
if nargin < 3 || isempty(direction)
    direction = 'ver';
end;
    
width = numel(Y)/height;
if width ~= floor(width)
    irerror(sprintf('Invalid height: number of image points not divisible by specified height: %d', height));
end;


cc = colormap();
ncolors = size(cc, 1);

nanana = isnan(Y);
Ytemp = Y(~nanana);
Ytemp = Ytemp(:);
mi = min(Ytemp);
ma = max(Ytemp);

Y(nanana) = 0;
Y(~nanana) = 1+(ncolors-1)*(Y(~nanana)-mi)/(ma-mi);


if strcmp(direction, 'hor')
    M = reshape(Y, width, height)';
else
    M = reshape(Y, height, width);
end;
imagesc(M);

colormap([0, 0, 0; cc]);


shading flat;

axis image;
axis off;
set(gca, 'XDir', 'normal', 'YDir', 'normal');
set(gca, 'XLim', [0, width+1], 'YLim', [0, height+1]);
format_frank();

