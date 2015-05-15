%> @file
%>@ingroup misc maths
%> @brief Shallow structure or cell comparison
%
%> @param o1
%> @param o2
%> @return flag
function flag = compare(o1, o2)
flag = 1;
if iscell(o1)
    n = numel(o1);
    for i = 1:n
        if ~compare(o1{i}, o2{i})
            flag = 0;
            break;
        end;
    end;
elseif isstruct(o1)
    ff = fields(o1);
    for i = 1:numel(ff)
        f = o1.(ff{i}); % value from 1st object
        if ischar(f)
            if ~strcmp(f,  o2.(ff{i}))
                flag = 0; break;
            end;
        else
            if ~(f == o2.(ff{i}))
                flag = 0; break;
            end;
        end;
    end;
elseif ischar(o1)
    flag = strcmp(o1, o2);
else
    flag = eq(o1, o2);
end;
