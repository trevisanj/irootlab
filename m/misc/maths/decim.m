%>@ingroup maths
%> @file
%> @brief Decimation by averaging
%
%> Decimation occurs by averaging every r columns of X.
%
%> @param X [no][nf] matrix
%> @param r Decimation factor. After decimation, size(Y, 2) = floor(size(X, 2)/r)
%> @return Decimated matrix.
function Y = decim(X, r)

[no, nf] = size(X);

nfnew = floor(nf/r);

Y = zeros(no, nfnew);

ptry = 1;
for i = 1:nfnew

    idx1 = (i-1)*r+1;
    idx2 = idx1+r-1;

    Y(:, ptry) = mean(X(:, idx1:idx2), 2);
    
    ptry = ptry+1;
end;
