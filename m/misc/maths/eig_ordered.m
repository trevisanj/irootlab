%>@ingroup maths
%>@file
%>@brief Returns eigenvectors of matrix ordered in descending order of eigenvalue.
%>
%> @sa MATLAB's <code>eig()</code> function
%
%> @param varargin see MATLAB's <code>eig()</code> function
%> @return <em>[vectors, lambdas]</em>
function [vv, ll] = eig_ordered(varargin)


% [vv, dd] = eigs(A, r); % eigenvectors, eigenvalues
[vv, dd] = eig(varargin{:}); % eigenvectors, eigenvalues

% the eig() function gives eigenvalues in ascending order, however I have
% experienced the opposite with a low-rank matrix. 

% Also this time I am not taking into account the presence of NaN eigenvalues.

% This creates an index vector at column 2 of the 'lambdas' variable
lambdas = diag(dd);
lambdas(:, 2) = (1:numel(lambdas))';
lambdas = sortrows(lambdas);

% However, the index vector is in ascending order and we want the opposite
indexes = lambdas(end:-1:1, 2);
vv = vv(:, indexes);
% vv = vv(:, 1:r);

ll = lambdas(end:-1:1, 1)';
% ll = ll(1:r);
