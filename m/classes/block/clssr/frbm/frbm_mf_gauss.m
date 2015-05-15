% function mm = mf_gauss(X, centers, radii)
%
% Inputs:
%   X: [1][nf] data point
%   centers: [no_rules][nf]
%   radii: [no_rules][nf]
%
% Output:
%   mm: [no_rules][nf]
function mm = mf_gauss(X, centers, radii)
[no_rules, nf] = size(centers);
mm = zeros(no_rules, nf);
for i = 1:no_rules
    mm(i, :) = exp(-(X-centers(i, :)).^2./(2*radii(i, :).^2));
end;
