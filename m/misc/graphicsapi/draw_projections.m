%>@ingroup graphicsapi maths
%>@file
%>@brief Draws projections of each row of DATA.X onto the column vector v
%>
%> Points are colored according to data.classes.
%>
%> This is 2D drawing. @c data.X must have 2 columns and @c v must have two elements.
%
%> @param data
%> @param v
function draw_projections(data, v)
X = data.X;
P = X*v*v';

for i = 1:data.no
    plot([X(i, 1), P(i, 1)], [X(i, 2), P(i, 2)], 'k--');
    hold on;
end;

X = P; % trick to save memory.
pieces = data_split_classes(data);

for i = 1:length(pieces)
    scatter(pieces(i).X(:, 1), pieces(i).X(:, 2), 30, find_color(i), 'filled');
end;

