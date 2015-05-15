%>@ingroup usercomm
%>@file
%>@brief Shows Bug dialogbox and rethrows error
%>
%> Verifies whether the error is a malfunction of bad usage. If the former, shows the bug dialog and rethrows. Otherwise, just rethrows.

function send_error(ME)

if ~strcmp(ME.identifier, 'IRootLab:bad')
    buggui(ME);
else
    irerrordlg(ME.message, 'Error!');
end;
rethrow(ME);
