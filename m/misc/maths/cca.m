%>@ingroup maths
%>@file
%>@brief Canonical Correlation Analysis
%>
%> <h3>Reference</h3>
%> Hastie et. al. 2001, The elements of statistical learning, exercise 3.18.
%
%> @param X "Input"
%> @param Y "Output"
%> @param P either the penalty coefficients of a penalty matrix itself
%> @return [A, B]
function [A, B] = cca(X, Y, P)

[no, nf] = size(X);

if ~exist('P', 'var')
    P = 0;
else
    [q, w] = size(P);
    if q ~= nf || w ~= nf
        % assumes the coefficients have been passed
        P = no*penalty_matrix(nf, P);
    else
    end;
end;


Y = data_normalize(Y, 's');
X = data_normalize(X, 's'); % We need this otherwise the correlation X'*Y needs normalization


if 1
    [A, B] = canoncorr(X, Y);
else
    % Hastie et. al. 2001, The elements of statistical learning, exercise
    % 3.18.
    
    % This algorithm is working fine
    
    p = min(size(X, 2), size(Y, 2))-1;
    
    M = (Y'*Y)^(-1/2)*(Y'*X)*(X'*X+P)^(-1/2);
    [U, D, V] = svd(M);
    
    B = (Y'*Y)^(-1/2)*U(:, 1:p);
    A = (X'*X+P)^(-1/2)*V(:, 1:p);
 end;
