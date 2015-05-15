%>@ingroup usercomm
%>@file
%>@brief Generates a warning
function irwarning(s)

dbstack;
disp(['WARNING: ' s]);
