%>@ingroup maths
%>@file
%>@brief Binary Search
%>
%> Written by Aroh Barjatya
%>
%> Binary search for values specified in vector 'var' within data vector 'x'
%> The data has to be pre-sorted in ascending or decending order
%> There is no way to predict how the function will behave if there 
%> are multiple numbers with same value.
%> returns the index values of the searched numbers
%>
%> @c flag_bin added by JT. @c flag_bin = 1 will cause to return the index corresponding to the highest number in case
%> of @c var being between two numbers.
%
%> @param x
%> @param var
%> @param flag_bin
%> @return @em index
function index = bsearch(x,var, flag_bin)

if nargin < 3
    flag_bin = 0;
end;

xLen = length(x);
[xRow xCol] = size(x);
if x(1) > x(xLen)	% means x is in descending order
    if xRow==1
        x = fliplr(x);  
    else
        x = flipud(x);
    end
    flipped = 1;
elseif x(1) <= x(xLen)	% means x is in ascending order
    flipped = 0;
else
    'badly formatted data. Type ''help bsearch\'')';
    return;
end

for i = 1:length(var)
    low = 1;
    high = xLen;
    if var(i) <= x(low)
        index(i) = low;
        continue;
    elseif var(i) >= x(high)
        index(i) = high;
        continue;
    end
    flag = 0;
    while (low <= high)
        mid = round((low + high)/2);
        if (var(i) < x(mid))
            high = mid;
        elseif (var(i) > x(mid))
            low = mid;
        else
            index(i) = mid;
            flag = 1;
            break;
        end
        if (low == high - 1)
            break
        end
    end
    if (flag == 1)
        continue;
    end
    if (low == high)
        index(i) = low;
    elseif flag_bin || ((x(low) - var(i))^2 > (x(high) - var(i))^2)
        index(i) = high;
    else
        index(i) = low;
    end
end

if flipped
    index = xLen - index + 1;
end
