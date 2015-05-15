%>@ingroup datasettools
%>@file
%>@brief draw3d2_get_minmax
%>
%> @sa data_draw_scatter3d2.m
%
%> @param data
%> @param idxfea
%> @param flags_min a long story...
%> @param ks a long story...
function [minmax, xyz] = draw3d2_get_minmax(data, idxfea, flags_min, ks)



X = data.X;
minmax = [min(X(:, idxfea(1:3))); max(X(:, idxfea(1:3)))];
span = minmax(2, :)-minmax(1, :);
xyz = [0, 0, 0];
for i = 1:3
    if flags_min(i)
        minmax(1, i) = minmax(1, i)-span(i)*ks(2);
        minmax(2, i) = minmax(2, i)+span(i)*ks(1);
        xyz(i) = minmax(1, i);
    else
        minmax(1, i) = minmax(1, i)-span(i)*ks(1);
        minmax(2, i) = minmax(2, i)+span(i)*ks(2);
        xyz(i) = minmax(2, i);
    end;
end;       

