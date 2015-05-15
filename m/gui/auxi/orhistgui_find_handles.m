%> @ingroup guigroup
%> @file
%> @brief Finds handles for orhistgui
function handles = orhistgui_find_handles()
H = findall(0, 'Name', 'orhistgui');
if isempty(H)
    irerror('orhistgui not open');
end;
handles = guidata(H);
