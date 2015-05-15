%>@ingroup globals ioio setupgroup sheware assert idata
%>@file
%>@brief Initializes the DB global
%>
%> Please check the source code for fields and defaults.
function db_assert()
global DB;
if isempty(DB)
    DB.host = 'bioph.lancs.ac.uk';
    DB.user = 'cells_user';
    DB.pass = 'meogrrk';
    DB.name = 'cells';
end;
