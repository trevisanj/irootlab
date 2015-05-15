%> @ingroup misc maths graphicsapi
%> @file
%> @brief Replaces infinite values by maximum/minimum
%
%> @param y Vector
%> @return y With +Inf/-Inf values replaced by maximum/minimum respectively
function y = protect_against_inf(y)
bo = y ~= Inf & y ~= -Inf;
if sum(bo) == 0
    y(1:end) = 0;
else
    y(y == Inf) = max(y(bo));
    y(y == -Inf) = min(y(bo));
end;
