%>@ingroup string
%>@file
%> @brief Returns the first element of a cell or the argument itself if it is not a cell.

%> @param c
%> @param n Bonus
function s = fel(c, n)
if iscell(c)
    if nargin() == 1
        n = 1;
    end;
    s = c{n};
else
    s = c;
end;
