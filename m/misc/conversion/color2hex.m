%>@ingroup conversion graphicsapi
%>@file
%>@brief Generates color string in HTML hexadecimal style
%
%> @param x 3-element vector, each element between 0 and 1
%> @return a 6-caracter string
function z = color2hex(x)
if numel(x) ~= 3
    error('Three numbers please');
end;
if sum(x > 1 | x < 0)
    error('Between 0 and 1 please');
end;
if size(x, 1) > 1
    x = x';
end;
z = dec2hex(floor([1 x]*255)); % Addex 1 so that MATLAB generates 2-digit hexadecimals
z = z(2:end, :)';
z = z(:)';
