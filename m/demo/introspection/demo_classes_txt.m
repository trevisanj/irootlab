%>@brief Creates a CSV file with a list of classes, similar to what is seen in blockmenu.m
%>@file
%>@ingroup introspection
%> @sa itemlist2cell.m
aa = {'block', 'sgs', 'peakdetector', 'fsg', 'irlog'};

cc = {};
for i = 1:numel(aa)
    l = classmap_get_list(aa{i});
    cc = [cc; itemlist2cell(l, 0, 1)];
end;

% Generates text string
s = char(10)*ones(size(cc, 1), 1);
for i = size(cc, 2):-1:1
    s = [char(cc(:, i)), s];
end;

filename = 'irr_classes.txt';
h = fopen(filename, 'w');

fwrite(h, s');
fclose(h);
edit(filename);