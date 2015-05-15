%>@ingroup misc
%>@file
%>@brief check_hsc
function check_hsc()
global HSC;
if numel(HSC) == 0
    welcome();
end;
HSC = 1;