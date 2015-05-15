%>@ingroup globals ioio sheware setupgroup
%>@file
%>@brief Resets the DB global
%>
%> @sa db_assert.m, connect_to_cells.m, irquery.m
function db_reset()
global DB;
DB = [];
