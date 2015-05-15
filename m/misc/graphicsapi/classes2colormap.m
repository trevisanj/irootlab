%>@ingroup graphicsapi conversion classlabelsgroup
%>@file
%>@brief Generates a colormap from an integer vector of classes.
%>
%> The vector may also have "refuses" and outlier indicators (-1, -2, -3, ...). These negative values will be marked as
%> black
%
%> @param y integer vector of classes
%> @param flag_skip Whether to skip the non-existent indexes. If FALSE, colormap will be filled with grays
%> @return cm
function cm = classes2colormap(y, flag_skip)

if nargin < 2 || isempty(flag_skip)
    flag_skip = 0;
end;

u1 = unique(y(y < 0));
u2 = unique(y(y >= 0));

n1 = numel(u1);
n2 = numel(u2);

cm = zeros(0, 3);
i = 1;
for class = min(u1):-1
    if sum(u1 == class) > 0
        cm(i, :) = [1, 1, 1]*0;
        i = i+1;
    else
        if ~flag_skip
            cm(i, :) = [1, 1, 1]*.5;
            i = i+1;
        end;
    end;
end;

j = 1;
for class = 0:max(u2)
    if sum(u2 == class) > 0
        cm(i, :) = rgb(find_color(j));
        i = i+1;
        j = j+1;
    else
        if ~flag_skip
            cm(i, :) = [1, 1, 1]*.5;
            i = i+1;
        end;
    end;
end;

