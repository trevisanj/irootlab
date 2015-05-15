%>@file
%>@ingroup graphicsapi ioio
%>@brief Saves figure as a FIG file
%
%> @param h =gcf() Handle to figure
%> @param fn =(auto/new) File name
function save_as_fig(h, fn)

if nargin < 1 || isempty(h)
    h = gcf();
end;
if nargin < 2 || isempty(fn)
    fn = find_filename('irr_figure', [], 'fig');
end;

hgsave(h, fn);
