%>@ingroup string htmlgen
%>@file
%>@brief HTML table where data items may have associated standard deviations
%>
%> This version of HTML table paints each cell with a colour proportional to corresponding element in M
%>
%> @sa html_comparison_std.m, html_confusion.m, html_comparison.m, html_table_std.m


%> @param M Square matrix or cell. If cell, may contain either numbers of strings
%> @param S Matrix of standard deviations. This one must be a matrix
%> @param rowlabels cell of row labels
%> @param collabels cell of column labels
%> @param cornerstr =''. String to put in the corner
%> @param minimum
%> @param maximum
%> @param pow =10. Color function power. See internal function cellcolor2()
%> @return s A string
function s = html_table_std_colors(M, S, rowlabels, collabels, cornerstr, minimum, maximum, pow)

flag_std = nargin > 1 && ~isempty(S);

if nargin < 5
    cornerstr = '';
end;
if nargin < 6 || isempty(minimum)
    minimum = min(M(:));
end;
if nargin < 7 || isempty(maximum)
    maximum = max(M(:));
end;
if nargin < 8 || isempty(pow)
    pow = 10;
end;


funla = @(x) ['<td class="bob"><div class="hec">', iif(isnumeric(x), mat2str(x), x), '</div></td>'];
hete = cellfun(funla, collabels, 'UniformOutput', 0);

s = ['<table class="bo">', 10];
s = cat(2, s, sprintf('<tr><td class="bobbor">%s</td>', cornerstr), cat(2, hete{:}), '</tr>', 10);
% mi = min(M(:));
for i = 1:size(M, 1)
    s = cat(2, s, '<tr><td class="bor"><div class="hel">', iif(isnumeric(rowlabels{i}), mat2str(rowlabels{i}), rowlabels{i}), '</td>', 10);
    for j = 1:size(M, 2)
        [fg, bg] = cellcolor2(M(i, j), minimum, maximum, pow);
        if flag_std
            ssij = ['&plusmn;', num2str(S(i, j))];
        else
            ssij = '';
        end;
        s = cat(2, s, '<td class="nu" style="background-color: #', bg, '; color: #', fg, ';">', ...
            num2str(M(i, j)), ssij, '</td>', 10);
    end;
    s = cat(2, s, '</tr>', 10);
end;
s = cat(2, s, '</table>', 10);


%=================================================================================================================================
%>@brief Calculates a background color based on percentage
%>
%> Sqrt improves the color representation, because it makes low values already some color
%> Color formula is:
%>   - Red: maximum;
%>   - Green and blue: sqrt(value)/sqrt(sum of row)
%
%> @param n intensity
%> @param ma Maximum
%> @retval [bgcolor] or [bgcolor, fgcolor]
function [fg, bg] = cellcolor2(n, min, max, pow)


% n = exp(n);
% min = exp(min);
% max = exp(max);

N = 100;
cm = autumn(N);
cm = cm(end:-1:1, :);

if min == max
    vbg = [.8, .8, .8];
else
    n = n^pow;
    min = min^pow;
    max = max^pow;
    idx = (n-min)/(max-min)*(N-1)+1;
    if idx < 1
        idx = 1;
    end;
    if idx > N
        idx = N;
    end;
    vbg = cm(round(idx), :);
end;
bg = color2hex(vbg);
fg = color2hex(iif(vbg(2) < .5, [1, 1, 1], [0, 0, 0]));



% 
% maximum = sqrt(maximum);
% if maximum == 0
%     maximum = 1;
% end;
% 
% if 1
%     bgcolor = [1, [1, 1]*(1-sqrt(n)/maximum)];
% else
%     bgcolor = [1, 1, 1];
% end;
% fgcolor = 1-bgcolor;
% 
% bgcolor = color2hex(bgcolor);
% fgcolor = color2hex(fgcolor);
% 
% if nargout == 1
%     varargout = {bgcolor};
% else
%     varargout = {bgcolor, fgcolor};
% end;
