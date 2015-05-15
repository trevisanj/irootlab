%>@ingroup string htmlgen
%>@file
%>@brief Creates HTML table from cell

%> @param cc Cell
%> @param flag_header =1. Whether to generate header row
%> @param flag_1stcolumn =0. Whether to generate distinguished first column
function s = cell2html(cc, flag_header, flag_1stcolumn)


if nargin < 2 || isempty(flag_header)
    flag_header = 1;
end;
if nargin < 3 || isempty(flag_1stcolumn)
    flag_1stcolumn = 0;
end;

[nr, nc] = size(cc);


s = ['<table class="bo">', 10];

irow = 1;
j = 0;
if flag_header
    
    s = cat(2, s, '<tr>', 10);
    for j = 1:nc
        x = cc{1, j};
        s = cat(2, s, '<td class="bob"><div class="hec">', ...
                      iif(flag_1stcolumn && j == 1, '<div class="bor">', ''), ...
                      iif(isnumeric(x), mat2str(x), x), ...
                      iif(flag_1stcolumn || j == 1, '</div>', ''), ...
                      '</div></td>', 10);
    end;
    s = cat(2, s, '</tr>', 10);
    irow = irow+1;
end;


for i = irow:nr
    s = cat(2, s, '<tr>', 10);
    for j = 1:nc
        x = cc{i, j};
        s = cat(2, s, '<td><div class="', iif(isnumeric(x), 'nu', ''), '">', ...
                      iif(flag_1stcolumn && j == 1, '<div class="bor">', ''), ...
                      iif(isnumeric(x), mat2str(x), x), ...
                      iif(flag_1stcolumn || j == 1, '</div>', ''), ...
                      '</div></td>', 10);
    end;
    s = cat(2, s, '</tr>', 10);
end;

s = cat(2, s, '</table>', 10);

