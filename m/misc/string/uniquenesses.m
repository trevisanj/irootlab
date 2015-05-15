%>@ingroup string conversion
%> @file
%> @brief Extract unique part of each string within a cell
%>
%> Iterates through the strings to find a piece in the middle that is different in each string.
%>
%> Update 18/06/2013: Removes all matches of (...) from strings before
%>
%> @param cc Cell of strings
%> @return dd Cell of strings
function dd = uniquenesses(cc)
n = numel(cc);
for i = 1:n
    cc{i} = regexprep(cc{i}, '\([a-zA-Z0-9]*\)', '');
end;

nn = cellfun(@numel, cc);
bk = 1;
flag_break = 0;
while 1
    for i = 1:n
        if bk > nn(i)
            flag_break = 1;
            break;
        end;
        if i == 1
            ch = cc{i}(bk);
        else
            if cc{i}(bk) ~= ch
                flag_break = 1;
                break;
            end;
        end;
    end;
    if flag_break
        break;
    end;
    bk = bk+1;
end;


ck = 0;
flag_break = 0;
while 1
    for i = 1:n
        if nn(i)-ck < 1
            flag_break = 1;
            break;
        end;
        if i == 1
            try
            ch = cc{i}(end-ck);
            catch me
                sdfs;
            end;
        else
            if cc{i}(end-ck) ~= ch
                flag_break = 1;
                break;
            end;
        end;
    end;
    if flag_break
        break;
    end;
    ck = ck+1;
end;



for i = 1:n
    dd{i} = cc{i}(bk:end-ck);
end;
