%>@ingroup string
%>@file
%>brief Formats number to feature in a figure
%> @todo Introduce setup for this function. E.g. Nature requires comma separators.
%
%> @param n A number
%> @return s A string
function s = format_number(n)

frac = n-floor(n);
s = '';
p = floor(n);
i = 1;
while 1
    r = mod(p, 1000);
    p = floor(p/1000);
    if r == 0 && p == 0
        if i == 1
            s = ['0' s];
        end;
        break;
    elseif p == 0
        if ~isempty(s); s = [',' s]; end;
        s = [sprintf('%d', r) s];
        break;
    else
        if ~isempty(s); s = [',' s]; end;
        s = [sprintf('%03d', r) s];
    end;
end;
