%>@ingroup maths
%>@file
%>@brief Divides each row of cc by its sum, or leaves it untouched if its sum is zero.
%>
%> Used to normalize a hits confusion matrix into a percentage confusion matrix.
%>
%> Please note that it does not work well with negative numbers.
%>
%> @sa clssr_d, irconfusion, clssr_ls
%
%> @param cc
%> @return matrix of same size as input
function cc = normalize_rows(cc)
cc = bsxfun(@rdivide, cc, sum(cc, 2)+realmin);
