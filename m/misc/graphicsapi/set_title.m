%>@ingroup graphicsapi
%>@file
%>@brief Sets figure title sensitive to object passed
%>
%> Uses the objects's @ref irobj::title property. If it is empty, simply uses @c s
%
%> @param s Specific title
%> @param obj Object get @ref irobj::title from
function set_title(s, obj)

st = s;
if ~isempty(obj.title)
    st = ['"', obj.title, '" - ', st];
end;
title(st);
