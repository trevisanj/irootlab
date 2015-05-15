%>@ingroup maths
%> @file
%> @brief Savitzky-Golay differentiation
%>
%> There are two ways to use it:
%>@code
%> [X_after] = diff_sg(X, [], order, porder, ncoeff);
%>@endcode
% or
%>@code
%> [X_after, x_after] = diff_sg(X, x, order, porder, ncoeff);
%>@endcode
%>
%> First case is when second parameter (x) is passed as an []
%
%> @param X Matrix
%> @param x x-axis values corresponding to the columns of @c X
%> @param order Differential order. Accepted values: 1 or 2
%> @param porder Polynomial order
%> @param ncoeff Number of filter coefficients. Must be off
%> @return <em>[X_after]</em> or <em>[X_after, x_after]</em> as described above.
function varargout = diff_sg(X, x, order, porder, ncoeff)

if ~exist('order', 'var')
    order = 1;
end;
if ~exist('porder', 'var')
    porder = 2;
end;
if ~exist('ncoeff', 'var')
    ncoeff = 9;
end;

if order ~= 1 && order ~= 2
    error('Accepted differential orders: 1 and 2 only!');
end;


if ncoeff/2 == floor(ncoeff/2)
    error('Number of filter coefficients must be odd!');
end;

flag_x = ~isempty(x);
[no, nf] = size(X);
factor = factorial(order);
nf_after = nf + ncoeff-1 - (ncoeff-1)*2; % first additive term is in account for convolution,
                                         % second (subtractive term is in account for the (ncoeff-1) border instabilities)
X_after = zeros(no, nf_after);


[b, g] = sgolay(porder, ncoeff); % g is a matrix containing one filter per column. i-th column is (i-1)-th derivative corresponding filter
H = g(:, order+1);
H = H(end:-1:1); % filter is reversed because it is designed by sgolay() for dot product, not convolution

for i = 1:no
    temp = conv(X(i, :), H);
    X_after(i, :) = temp(ncoeff:end-ncoeff+1)*factor;
end;

if flag_x
    offset = (ncoeff-1)/2;
    x_after = x(1+offset:nf-offset);
end;

if ~flag_x
    varargout = {X_after};
else
    varargout = {X_after, x_after};
end;


