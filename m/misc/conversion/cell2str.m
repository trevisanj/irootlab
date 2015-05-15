%> @ingroup conversion string
%> @file
%> @brief Converts cell to string.
%> The generated string will produce the same cell (i.e., c again) if eval()'uated.
%>
%> Works only if the elements from c are strings. Originally designed to be used by datatool.
%
%>@param c
%>@return \em s
function s = cell2str(c)
[q, w] = size(c);
s = '{';
for i = 1:q
    if i > 1
        s = [s, '; '];
    end;
    for j = 1:w
        if j > 1; s = [s ', ']; end;
        if isstr(c{i, j})
            s = [s '''' c{i, j} ''''];
        else
            s = [s mat2str(c{i, j})];
        end;
    end;
end;
s = [s '}'];
