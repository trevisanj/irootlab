%>@ingroup graphicsapi
%>@file
%>@brief Moves GUI "Northwest" (where Lancaster is)
%
%> @param hObject
function gui_set_position(hObject)
if 0
    position = get(hObject, 'Position');
    position(1:2) = [0 0];
    set(hObject, 'Position', position );
else
%     movegui(hObject, 'center');
    movegui(hObject, 'northwest');
end;
