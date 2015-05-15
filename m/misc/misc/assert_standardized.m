%>@ingroup misc assert
%>@file
%>@brief Checks whether the columns of X have mean zero and variance 1 up to a certain tolerance.
%>
%> For instance, if tolerance is 0.02, -0.02 <= mean <= 0.02, and 0.98 <= variance <= 1.02 will be accepted.
%
%> @param X Input matrix
%> @param tolerance =0.001 Tolerance
%> @return Nothing. If fails, wil generate an error.
function assert_standardized(X, tolerance)
if nargin < 2 || isempty(tolerance)
    tolerance = 0.001;
end;
vv = var(X, 1);
[v, i] = max(abs(vv-1)); % Maximum absolute deviation around 1
if v > tolerance
    irerror(sprintf('Invalid variable variance! Expecting: 1; found: %g', vv(i)));
end;

mm = max(abs(mean(X)));

if mm > tolerance
    irerror(sprintf('Invalid variable mean! Expecting: 0; found: %g', mm));
end;
