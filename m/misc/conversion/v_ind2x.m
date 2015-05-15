%>@ingroup conversion maths
%>@file
%>@brief Converts indexes to x by linear [inter/extra]polation.
%>
%> Indexes can be fractionary or out of range.
%>
%> @note This function uses <code>polyfit()</code> and <code>polyval()</code> to calculate the result
%
%> @param x
%> @param indexes
%> @return xout
function xout = v_ind2x(x, indexes)

p = polyfit(1:length(x), x, 1);
xout = polyval(p, indexes);

