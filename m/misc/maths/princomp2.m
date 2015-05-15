%>@ingroup maths
%>@file
%>@brief Principal Component Analysis (PCA)
%>
%> PCA formula:
%>@code
%> scores = X*loadings
%>@endcode
%>
%> Loadings are the eigenvectors of the X's scatter matrix. The scatter matrix is defined ad X'*X, a simmetric positive definite or semi-definite
%> with rank <code>r <= @ref nf</code>.
%>
%> Meanings of the possible outputs:
%> @arg @c scores: <code>[@ref no][r]</code> PCA scores (@c r is the rank of the dataset's scatter matrix).
%> @arg @c loadings: <code>[@ref nf][r]</code> loadings matrix.
%> @arg @c lambdas: <code>[r]x[1]</code> contains the eigenvalues of the scatter matrix.
%>
%> Note: the loadings vectors sometimes happen to point at the opposite directions of those obtaines by MATLAB's princomp() (not really a problem).
%>
%> <h3>References</h3>
%> ﻿[1] R. O. Duda, P. E. Hart, and D. G. Stork, Pattern Classification, 2nd ed. New York: John Wiley & Sons, 2001.
%
%> @param X [@ref no]x[@ref nf] matrix
%> @return <code>[loadings]</code> or <code>[loadings, scores]</code> or <code>[loadings, scores, lambdas]</code>
function [varargout] = princomp2(X)

nf = size(X, 2);

if 0
    X = data_normalize(X, 'c'); % center
end;

cc = cov(X); % Covariance matrix
r = rank(cc);

[vv, ll] = eig_ordered(cc); % eigenvectors, eigenvalues

vv = adjust_unitnorm(vv);

if nargout() == 1
    varargout = {vv};
elseif nargout() == 2
    varargout = {vv, X*vv};
elseif nargout() == 3
    varargout = {vv, X*vv, ll};
end;
