%>@file
%>@ingroup graphicsapi ioio
%>@brief Saves PNG
%
%> @param h =gcf() Handle to figure
%> @param fn =(new) File name
%> @param dpi =0 Dots Per Inch = resolution. 0 = screen resolution
function save_as_png(h, fn, dpi)

pause(0.1); % It may be work to let MATLAB get sorted before saving

if nargin < 1 || isempty(h)
    if is_2014 % Working around changes starting from R2014a
        f = gcf();
        h = f.Number;
    else
        h = gcf();
    end;
end;
if nargin < 2 || isempty(fn)
    fn = find_filename('irr_figure', [], 'png');
end;
if nargin < 3 || isempty(dpi)
    dpi = 0;
end;

% This did the trick!!! Saving beautifully now
set(h, 'PaperPositionMode', 'auto', 'Units', 'pixels');

print(['-f', int2str(h)], '-dpng', ['-r', int2str(dpi)], '-opengl', fn);
