%>@ingroup datasettools
%>@file
%>@brief draw3d2_adjust
function  [minmax, xyz] = draw3d2_adjust(data, idxfea, flags_min, ks)

global SCALE;

[minmax, xyz] = draw3d2_get_minmax(data, idxfea, flags_min, ks);

feanames = data.get_fea_names(idxfea);
xlabel(feanames{1});
ylabel(feanames{2});
zlabel(feanames{3});

box off;
grid on;
% axis off;


% minmax = [min(data.X(:, idxfea(1:3))); max(data.X(:, idxfea(1:3)))];
% spans = minmax(2, :)-minmax(1, :);
% xyz = [0, 0, 0];
% k1 = 1.1;
% k2 = 1.5;
% for i = 1:3
%     if flags_min(i)
%         minmax(1, i) = minmax(1, i)-spans(i)*k2;
%         minmax(2, i) = minmax(2, i)+spans(i)*k1;
%         xyz(i) = minmax(1, i);
%     else
%         minmax(1, i) = minmax(1, i)-spans(i)*k1;
%         minmax(2, i) = minmax(2, i)+spans(i)*k2;
%         xyz(i) = minmax(2, i);
%     end;
% end;


data2 = [minmax; xyz];
perms = [1 2 3; 2 3 1; 3 1 2];
map = [1 2 2 1 1; 1 1 2 2 1; 3 3 3 3 3];
for i = 1:3
    xx = data2(map(perms(i, 1), :), 1);
    yy = data2(map(perms(i, 2), :), 2);
    zz = data2(map(perms(i, 3), :), 3);
    
    plot3(xx, yy, zz, 'k', 'LineWidth', scaled(2));
end;

set(gca, 'XLim', minmax(:, 1)');
set(gca, 'YLim', minmax(:, 2)');
set(gca, 'ZLim', minmax(:, 3)');

format_frank();
box off;
