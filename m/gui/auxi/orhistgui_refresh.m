%> @ingroup guigroup
%> @file
%> @brief Refreshes controls in orhistgui
function orhistgui_refresh()
handles = orhistgui_find_handles();
listbox_load_from_workspace('irdata', handles.popupmenu_data, 1);
orhistgui_view1();
orhistgui_view2(0);
