%>@ingroup graphicsapi
%>@file
%>@brief Traces a line and an arrow in direction defined by v
%
%> @param v must be a COLUMN vector
%> @param linescale =10
%> @param arrowscale =3
function draw_direction(v, linescale, arrowscale)

if ~exist('linescale')
    linescale = 10;
end;
if ~exist('arrowscale')
    arrowscale = 3;
end;

x = v(1, 1);
y = v(2, 1);
plot(linescale*[-x, x], linescale*[-y, y], 'k--');
hold on;
compass(-arrowscale*x, -arrowscale*y, 'k'); % represents first eigenvector of S_W^(-1)*S_B as an arrow

