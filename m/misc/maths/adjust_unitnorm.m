%> @ingroup maths
%> @file
%> @brief Normalizes column vectors to unit norm

%> @param L Loadings matrix
%> @return @em L Adjusted Loadings matrix
function L = adjust_unitnorm(L)
for i = 1:size(L, 2)
    v = L(:, i);
    v = v/norm(v);
    L(:, i) = v;
end;

