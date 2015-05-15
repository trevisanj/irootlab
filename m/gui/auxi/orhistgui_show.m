%> @ingroup guigroup
%> @file
%> @brief Calls GUI to preview the action outlier removal.
%
%> @param blk A @c blmisc_rowsout_uni block.
function orhistgui_show(blk)

H = findall(0, 'Name', 'orhistgui');
if isempty(H)
    orhistgui(blk, 1);
else
%     uicontrol(H); % Tries to bring to focus
end;
% orhistgui_set_remover(blk);
