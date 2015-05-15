%>@ingroup string htmlgen
%>@file
%>@brief Calculates a background color based on percentage
%>
%> Sqrt improves the color representation, because it makes low values already some color
%> Color formula is:
%>   - Red: maximum;
%>   - Green and blue: sqrt(value)/sqrt(sum of row)
%
%> @param n intensity
%> @param ma Maximum
%> @param flag_hex =0. If true, returns hexadecimal strings to insert into HTML code, otherwise returns 3-element vectors containing the RGB intensities.
%> @return [bgcolor] or [bgcolor, fgcolor]
function varargout = cellcolor(n, ma, flag_hex)

if ~exist('flag_hex', 'var')
    flag_hex = 0;
end;

ma = sqrt(ma);
if ma == 0
    ma = 1;
end;

n(isnan(n)) = 0;

if 1
    bgcolor = [1, [1, 1]*(1-sqrt(n)/ma)];
else
    bgcolor = [1, 1, 1];
end;
fgcolor = 1-bgcolor;

if flag_hex
    bgcolor = color2hex(bgcolor);
    fgcolor = color2hex(fgcolor);
end;

if nargout == 1
    varargout = {bgcolor};
else
    varargout = {bgcolor, fgcolor};
end;
