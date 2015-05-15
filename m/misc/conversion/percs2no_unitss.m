%> @ingroup conversion maths
%>@file
%>@brief Converts percents to number of units with extra care
%>
%> Extra care is taken so that:
%> @arg no elements in output be zero
%> @arg sum of elements in output does not surpass "total"
%
%> @param percs
%> @param total
%> @return no_unitss
function no_unitss = percs2no_unitss(percs, total)
if sum(percs) > 1
    irerror('Sum of percentages must be <= 1!');
end;
if find(percs <= 0)
    irerror('All percentages must be a positive non-zero!');
end;

np = length(percs);
no_unitss = zeros(1, np);

% The strategy is to start giving units to the smallest percentages first
[vals, idxs] = sort(percs);
for i = 1:np
    if i < np
        no_unitss(idxs(i)) = max(1, round(vals(i)*total)); % Care 1
    else
        sofar = sum(no_unitss);
        temp = max(1, round(vals(i)*total)); % Care 1
        if sofar+temp > total 
            % Care 2: If would blow, the guy due to receive the most will actually get the remainder
            temp = total-sofar;
            if temp <= 0
                irerror('Number of units =%d is too small to split!', total);
            end;
            no_unitss(idxs(i)) = temp;
        else
            no_unitss(idxs(i)) = temp;
        end;
    end;
end;
