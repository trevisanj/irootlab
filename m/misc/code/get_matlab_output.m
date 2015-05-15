%>@ingroup codegen string
%>@file
%>@brief Returns a string containing the text that MATLAB shows when you type the variable name in the command prompt

function s = get_matlab_output(o, flag_cell)

if ~exist('flag_cell')
    flag_cell = 0;
end;

s = regexp(cellstr(evalc('o')), '\n', 'split');
s = s{1};
% s = w = cellfun(@(a) [a '$'], {'10', 'log(1)', '444'}, 'UniformOutput', 0);[cellfun(s(8:end-2);
% s = strtrim(s(8:end-2));
s = s(7:end-2);

s = [[class(o), '; ', o.get_ancestry()], s];

if ~flag_cell
    s = sprintf('%s\n', s{:});
    s = s(1:end-1);
end;
