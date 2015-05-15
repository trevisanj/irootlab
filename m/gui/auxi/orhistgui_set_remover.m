%> @ingroup guigroup
%> @file
%> @brief Sets block of orhistgui
%
%> @param blk A @c blmisc_rowsout_uni block.
function orhistgui_set_remover(blk)
if ~isa(blk, 'blmisc_rowsout_uni')
    irerror('Remover needs to be of class blmisc_rowsout_uni!');
end;
handles = orhistgui_find_handles();
handles.remover = blk;
guidata(handles.figure1, handles);
orhistgui_refresh();
