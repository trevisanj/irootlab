%>@ingroup maths
%>@file
%> @brief Calculates the Mahalanobis distances of the rows in X
%
%> @param X
%> @return Vertical vector of distances
function distances = maha(X)

if rank(cov(X)) < size(X, 2)
    irerror('Covariance matrix is singular, try removing low-variance feature');
end;

no = size(X, 1);
means = mean(X, 1);
Xcentered = X-repmat(means, no, 1);
distances = zeros(no, 1);
Cinv = inv(cov(Xcentered));
for i = 1:no
    v = Xcentered(i, :)';
    distances(i) = v'*Cinv*v;
end;
distances = sqrt(distances);

