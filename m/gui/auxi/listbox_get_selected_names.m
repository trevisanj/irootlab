%>@ingroup misc
%>@file
%>@brief Returns the selected elements of a listbox or popupmenu as a cell of strings

function a = listbox_get_selected_names(h_listbox)
a = get(h_listbox, 'String');
if ~isempty(a)
    if length(a) == 1 && ismember(a{1}, {'(none)', '(leave blank)'})
        a = {};
    else
        ii = get(h_listbox, 'Value');
        a = a(ii);
    end;
end;
