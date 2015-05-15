%>@ingroup misc
%>@file
%>@brief Returns the first selected string o a listbox of popupmenu

function s = listbox_get_selected_1stname(h_listbox)
s = '';
a = get(h_listbox, 'String');
if ~isempty(a)
    a = a(get(h_listbox, 'Value'));
    if ~(a{1}(1) == '(')
        s = a{1};
    end;
end;
