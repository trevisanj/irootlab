%>@ingroup graphicsapi
%>@file
%>@brief Assigns y-limits based on [ymin, ymax] pair
%
%> @param yy [ymin, ymax] pair; or @ref irdata object from where to extract y-limits
function format_ylim(yy)

if isa(yy, 'irdata')
    temp = yy.X(:);
    yy = [min(temp), max(temp)];
elseif isnumeric(yy)
    yy = [min(yy(:)), max(yy(:))];
end;

d = diff(yy);
if d < 0
    irerror('Y-limits need be non-decreasing!');
end;
if d == 0
    y = yy(1);
    ylim([y-1, y+1]);
else
    edge = d*0.02;
    ylim(yy+[-edge, edge]);
end;