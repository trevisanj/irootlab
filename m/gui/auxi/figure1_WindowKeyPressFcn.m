%>@ingroup misc
%>@file
%>@brief Part of the context-sensitive help system
%> Executes on key press with focus on figure1 or any of its controls.
function figure1_WindowKeyPressFcn(hObject, eventdata, handles)
if ismember(eventdata.Key, {'f1', 'F1'})
    call_help(hObject);
end;
