%>@ingroup string htmlgen
%>@file
%>@brief HTML table where data items may have associated standard deviations
%>
%> @sa html_comparison_std.m, html_confusion.m, html_table_std_colors.m, html_comparison.m


%> @param M Square matrix or cell. If cell, may contain either numbers of strings
%> @param S (Optional) Matrix of standard deviations. This one must be a matrix
%> @param rowlabels cell of row labels
%> @param collabels cell of column labels
%> @param B matrix with 2-bit elements: less significant bit: "flag_better"; most significant bit: "statistically significant?"
%> @param cornerstr =''. String to put in the corner
%> @return s A string
function s = html_table_std(M, S, rowlabels, collabels, B, cornerstr)

if nargin < 5
    B = [];
end;
if isempty(S)
    S = zeros(size(M));
end;
flag_colour = ~isempty(B);
if nargin < 6
    cornerstr = '';
end;



funla = @(x) ['<td class="bob"><div class="hec">', iif(isnumeric(x), mat2str(x), x), '</div></td>'];
if flag_colour
    fun = @(x, b, s) [sprintf('<td class="nu"><div class="%s"><div class="%s">', ...
                              iif(bitand(b, 1), 'backbet', ''), ...
                              iif(bitand(b, 2), ' foresig', '')), ...
                      iif(isnumeric(x), mat2str(x), x), iif(s == 0, '', ['&plusmn;', mat2str(s)]), '</div></div></td>'];
    
    if iscell(M)
        M = cellfun(fun, M, num2cell(B), num2cell(S), 'UniformOutput', 0);
    else
        M = arrayfun(fun, M, B, S, 'UniformOutput', 0);
    end;
else
    fun = @(x, s) ['<td class="nu">', iif(isnumeric(x), mat2str(x), x), iif(s == 0, '', ['&plusmn;', mat2str(s)]), '</td>'];
    if iscell(M)
        M = cellfun(fun, M, num2cell(S), 'UniformOutput', 0);
    else
        M = arrayfun(fun, M, S, 'UniformOutput', 0);
    end;
end;



hete = cellfun(funla, collabels, 'UniformOutput', 0);


% Go!
s = ['<table class="bo">', 10];

s = cat(2, s, sprintf('<tr><td class="bobbor">%s</td>', cornerstr), cat(2, hete{:}), '</tr>', 10);

for i = 1:size(M, 1)
    s = cat(2, s, '<tr><td class="bor"><div class="hel">', iif(isnumeric(rowlabels{i}), mat2str(rowlabels{i}), rowlabels{i}), '</td>', M{i, :}, '</tr>', 10);
end;
s = cat(2, s, '</table>', 10);

