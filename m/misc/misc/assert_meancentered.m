%>@ingroup misc assert
%> @file
%> @brief Checks whether the columns of X have mean zero up to a certain tolerance.
%>

%> @param X Input matrix
%> @param tolerance =0.0001 . A value of 0.0001 means that each variable mean needs to be <= 0.01% * its maximum absolute value
%> @return Nothing. If fails, wil generate an error.
function assert_meancentered(X, tolerance)
if nargin < 2 || isempty(tolerance)
    tolerance = 0.0001;
end;

extremes = max(abs(X), [], 1);
mm = mean(X, 1);
idx = find(abs(mm) > extremes*tolerance); %#ok<*EFIND>
if ~isempty(idx)
    irerror(sprintf('X matrix is not mean-centered, for example, %g mean is not acceptable!', mm(idx(1))));
end;
