%>@ingroup graphicsapi
%>@file
%>@brief Returns a color
%
%> @param i
%> @return x 3-element RGB vector
function x = find_color_stackedhist(i)
fig_assert();
global COLORS_STACKEDHIST;
x = COLORS_STACKEDHIST{mod(i-1, length(COLORS_STACKEDHIST))+1};

% Converts to 0-1 if COLORS has values above 0-1
cc = cell2mat(COLORS_STACKEDHIST);
if any(cc(:) > 1)
    x = x/255;
end;
