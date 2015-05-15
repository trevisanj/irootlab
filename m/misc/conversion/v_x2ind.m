%>@ingroup conversion maths
%>@file
%>@brief Determines the indexes in x corresponding to v by proximity measure
%
%> @param v
%> @param x
%> @return indexes
function indexes = v_x2ind(v, x)

[rows, cols] = size(v);
indexes = zeros(rows, cols);
for i = 1:rows
    for j = 1:cols
        [val, indexes(i, j)] = min(abs(x-v(i, j)));
    end;
end;

