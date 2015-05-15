%>@ingroup string
%> @file
%> @brief Replaces underscores with a '-'
%>
%> @param s string of cell of strings
%> @return a string, if the input is a string, or a cell of strings, if the input is a cell of strings
function s = replace_underscores(s)
flag_cell = iscell(s);
if ~flag_cell
    s = {s};
end;

for i = 1:numel(s)
    s{i}(s{i} == '_') = '-';
end;

if ~flag_cell
    s = s{1};
end;