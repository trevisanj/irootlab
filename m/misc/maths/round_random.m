%>@ingroup maths
%>@file
%>@brief Now works as regular round()
%>
%> 20090501: I switched this to work exactly like round() so identical
%> numbers will give identical results
%>
%> This function used to round randomly either to the floor or ceiling in case an
%> element of x is exactly zzz.5
%
%> @param x
%> @return rounded x
function x = round_random(x)

x = round(x);

return;

for i = 1:length(x)
    if x(i) ~= floor(x(i)) && x(i)-floor(x(i)) == ceil(x(i))-x(i)
        x(i) = round(floor(x(i))+rand());
    else
        x(i) = round(x(i));
    end;
end;
