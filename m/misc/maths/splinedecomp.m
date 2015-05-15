%>@ingroup maths
%>@file
%>@brief Spline decomposition
%>@code
%> [X_after]
%> [X_after, x_after]
%> [X_after, x_after, Basis] =
%> splinedecomp(X, x = [], no_basis, breaks, order = 6)
%>@endcode
%>
%> <h3>References</h3>
%> ﻿[1] J. Ramsay, G. Hooker, and S. Graves, Functional Data Analysis with R and MATLAB. New York: Springer, 2009.
%> Function @c create_bspline_basis
%> [2] Jim Ramsay, B. W. Silverman. Functional Data Analysis. 2nd Ed. Springer. 2005.
%
%> @param X
%> @param x
%> @param no_basis
%> @param breaks
%> @param order
function varargout = splinedecomp(X, x, no_basis, breaks, order)

[no, nf] = size(X);
tt = 1:nf;

if ~exist('order', 'var')
    order = 6;
end;
if ~exist('breaks', 'var') || isempty(breaks)
    breaks = linspace(1, nf, no_basis-order+2);
end;

if ~exist('x', 'var') || isempty(x)
    x = 1:nf;
end;

bb = create_bspline_basis([1, nf], no_basis, order, round(breaks));

% First makes a new x vector.
% It will contain the x-axis location where the splines peak
PREC = 1000; % This number only determines the precision and does not affect anything else.
tt2 = linspace(1, nf, PREC); 
p = polyfit(tt, [data.fea_x], min(nf-1, 10)); % Gives a warning but who cares
x2 = polyval(p, tt2);
basismat = eval_basis(tt2, bb); % bases as columns
[vals, idxs] = max(basismat);
xx = x2(idxs);

 
% Now the main task   
% We gotta get the loadings matrix
tt3 = 1:nf;
B = eval_basis(tt3, bb);
L = B*inv(B'*B); % L, the "loadings" matrix

X = X*L;

if nargout == 1
    varargout = {X};
elseif nargout == 2
    varargout = {X, xx};
elseif varargout == 3
    varargout = {X, xx, B};
end;

