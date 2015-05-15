%>@ingroup graphicsapi
%>@file
%>@brief Returns a color (3-element RGB vector)
%
%> @param i
%> @return x 3-element RGB vector
function x = find_color(i)
fig_assert();
global COLORS;
x = COLORS{mod(i-1, length(COLORS))+1};

% Converts to 0-1 if COLORS has values above 0-1
cc = cell2mat(COLORS);
if any(cc(:) > 1)
    x = x/255;
end;
