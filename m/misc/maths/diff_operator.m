%>@ingroup maths
%> @file
%> @brief Creates differentiation matrix.
%>
%> Creates a <code>[nf-order]x[nf]</code> differential operator matrix @c D so that <code> D*x = diff(x, order)
%> </code>
%
%> @param nf
%> @paran order
%> @return D
function D = diff_operator(nf, order)

if order == 0
    D = eye(nf, nf);
else
    D = diff_operator(nf-1, order-1)*diff_operator1(nf);
end;

%>@cond
% creates a differential operator of order 1
function D = diff_operator1(nf)
D = zeros(nf-1, nf);
for i = 1:nf-1
    D(i, i) = -1;
    D(i, i+1) = 1;
end;

%>@endcond
