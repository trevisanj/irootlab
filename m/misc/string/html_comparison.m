%>@ingroup string htmlgen
%>@file
%>@brief Transforms comparison matrix into HTML
%>
%> @sa html_comparison_std.m, html_confusion.m, html_table_std_colors.m, html_table_std.m
%
%> @param M Square matrix or cell. If cell, may contain either numbers of strings
%> @param labels cell of labels
%> @param B matrix with 2-bit elements: less significant bit: "flag_better"; most significant bit: "statistically significant?"
%> @param cornerstr =''. String to put in the corner
%> @return s A string
function s = html_comparison(M, labels, B, cornerstr)

flag_colour = nargin > 3;


funla = @(x) ['<td class="bob"><div class="hec">', iif(isnumeric(x), mat2str(x), x), '</div></td>'];
if flag_colour
    fun = @(x, b) [sprintf('<td class="nu"><div class="%s"><div class="%s">', iif(bitand(b, 1), 'backbet', ''), iif(bitand(b, 2), ' foresig', '')), iif(isnumeric(x), mat2str(x), x), '</div></div></td>'];
    
    if iscell(M)
        M = cellfun(fun, M, num2cell(B), 'UniformOutput', 0);
    else
        M = arrayfun(fun, M, B, 'UniformOutput', 0);
    end;
else
    fun = @(x) ['<td class="nu">', iif(isnumeric(x), mat2str(x), x), '</td>'];
    if iscell(M)
        M = cellfun(fun, M, 'UniformOutput', 0);
    else
        M = arrayfun(fun, M, 'UniformOutput', 0);
    end;
end;



hete = cellfun(funla, labels, 'UniformOutput', 0);


corner = '';

% Go!
s = ['<table class="bo">', 10];

s = cat(2, s, sprintf('<tr><td class="bobbor">%s</td>', corner), cat(2, hete{:}), '</tr>', 10);

for i = 1:size(M, 1)
    s = cat(2, s, '<tr><td class="bor"><div class="hel">', iif(isnumeric(labels{i}), mat2str(labels{i}), labels{i}), '</td>', M{i, :}, '</tr>', 10);
end;
s = cat(2, s, '</table>', 10);

