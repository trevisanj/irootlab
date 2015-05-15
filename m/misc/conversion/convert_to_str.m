%> @ingroup conversion string codegen
%> @file
%> @brief Makes it into something that can be eval()'ed
%
%>@param c
%>@return \em s
function s = convert_to_str(c)
if isnumeric(c)
    s = mat2str(c);
elseif isstr(c)
    s = ['''', c, ''''];
elseif iscell(c)
    s = '{';
    for i = 1:size(c, 1)
        if i > 1; s = [s, '; ']; end;
        for j = 1:size(c, 2)
            if j > 1; s = [s ', ']; end;
            s = [s, convert_to_str(c{i, j})];
        end;
    end;
    s = [s '}'];
end;

