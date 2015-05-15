%>@ingroup gencode string
%>@file
%>brief Replaces invalid characters in name with an underscore ('_')
%
%> @param name
function name = good_varname(name)
len = size(name, 2);
for i = 1:len
    ch = name(i);
    if sum(ch == [65:65+25 97:97+25 48:48+9]) == 0 && sum(ch == ['_']) == 0
        name(i) = '_';
    end;
end;

