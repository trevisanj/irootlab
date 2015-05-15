%>@ingroup maths
%>@file
%>@brief Linear combination of differential operators.
%>
%> Returns a <code>[nf]x[nf]</code> symmetric matrix. It contains a weighted sum of different matrices <code>D_i'*D_i</code>. the coefficients of the sum are 
%> given by @c dcoeff. @c D_0 is <code>eye(nf, nf)</code>. @c D_i is the i-th order differential operator such that <code>D_i*x = diff(x, i).</code>
%
%> @param nf Number of features
%> @param dcoeff Coefficient vector for 0th, 2nd, 3rd derivative and so on
%> @return See above.
function P = penalty_matrix(nf, dcoeff)

P = zeros(nf, nf);
for i = 1:length(dcoeff)
    D = diff_operator(nf, i-1);
    P = P+dcoeff(i)*(D'*D);
end;
