%>@ingroup graphicsapi
%>@file
%>@brief Formats a figure according to Frank's rules (Times New Roman)
%
%> @param F =gcf()
%> @param scale =1 Obsolete. Uses global SCALE now
%> @param handles other handles to be formatted as well (that wouldn't be automatically picked)
function format_frank(F, scale, handles)
fig_assert();
global FONT FONTSIZE SCALE;

if ~exist('F', 'var') || isempty(F)
    F = gcf();
end;

if isempty(FONT)
    font = 'Times';
    irwarning('FONT global not present, using default ''Times''.');
else
    font = FONT;
end;
if isempty(FONTSIZE)
    fontsize = 36;
    irwarning('FONTSIZE global not present, using default 36.');
else
    fontsize = FONTSIZE;
end;
    


a = gca(); %get(F, 'CurrentAxes');
l1 = get(a, 'Xlabel');
l2 = get(a, 'Ylabel');
l3 = get(a, 'Zlabel');
t = get(a, 'Title');

if ~exist('handles', 'var')
    handles = [];
end;
handles = cat(2, handles, [a, l1, l2, l3, t]);

for i = 1:length(handles)
    o = handles(i);
%     set(o, 'FontName', 'Times New Roman');
    set(o, 'FontName', font);
    set(o, 'FontSize', fontsize*SCALE);
    set(o, 'LineWidth', scaled(2));
end;

set(a, 'Box', 'on');
set(a, 'LineWidth', scaled(2));
