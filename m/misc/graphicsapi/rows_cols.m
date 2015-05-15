%>@ingroup graphicsapi
%>@file
%>@brief rows_cols
%
%> @param num
%> @param proportion
%> @return [r, c]
function [r, c] = rows_cols(num, proportion)

% num = ceil(num/2)*2; % "rounds" num to the next integer

MULT = 10000; % improves precision

r = round(sqrt(num*proportion*MULT));
c = ceil(num*MULT/r);

r = ceil(r/sqrt(MULT));
c = ceil(num/r);

