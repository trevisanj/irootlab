%>@ingroup guigroup
%>@file
%>@brief Error dialog

function irerrordlg(errorstring, dlgname)
if nargin < 2
    dlgname = 'Error';
end;
h = errordlg(errorstring, dlgname, 'modal');
uiwait(h);
