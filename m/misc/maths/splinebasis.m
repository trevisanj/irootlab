%>@ingroup maths
%>@file
%>@brief Splines transformation matrix
%>
%> This matrix transforms a dataset into the coefficients for reconstruction using a spline basis. The transformation matrix is therefore the pseudo-inverse <code>B/(B'*B)</code> of the spline basis.
%>
%> <h3>References:</h3>
%> [1] Jim Ramsay, B. W. Silverman. Functional Data Analysis. 2nd Ed. Springer. 2005.
%> ﻿[2] J. Ramsay, G. Hooker, and S. Graves, Functional Data Analysis with R and MATLAB. New York: Springer, 2009.
%> Function @c create_bspline_basis

%
%> @param nf Number of features
%> @param no_basis Number of basis vectors
%> @param breaks =[] Break points. Check reference [1]
%> @param order =6 Spline order. Check reference [1]
%> @return The pseudo-inverse <code>B/(B'*B)</code> of the spline basis.
function L = splinebasis(nf, no_basis, breaks, order)

if ~exist('order', 'var')
    order = 6;
end;
if ~exist('breaks', 'var') || isempty(breaks)
    breaks = linspace(1, nf, no_basis-order+2);
end;

bb = create_bspline_basis([1, nf], no_basis, order, round(breaks));

 
% Now the main task   
% We gotta get the loadings matrix
tt3 = 1:nf;
B = eval_basis(tt3, bb);
L = B/(B'*B); % L, the "loadings" matrix
