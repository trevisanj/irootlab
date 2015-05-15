%> @ingroup guigroup
%> @file
%> @brief Draws histogram in orhistgui
function orhistgui_view1()
handles = orhistgui_find_handles();
cla(handles.axes1, 'reset');
axes(handles.axes1); %#ok<*MAXES>
hold off;
blk = handles.remover;
if ~isempty(blk)
    blk.draw_histogram();
    set(handles.text_howmany, 'String', sprintf('%d of %d to be removed', blk.no-length(blk.map), blk.no));
else
    set(handles.text_howmany, 'String', 'Outlier removal block not set');
end;