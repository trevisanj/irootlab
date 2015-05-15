%>@ingroup maths
%>@file
%>brief Accumulated sum of the columns of @c X
%>
%> Does the same as MATLAB cumsum().
%
%> @param X
%> @return I
function I = integrate(X)

[no, no_t] = size(X);
I = zeros(no, no_t);
ii = 0;
for i = 1:no_t
    if i == 1
        I(:, i) = X(:, i);
    else
        I(:, i) = I(:, i-1)+X(:, i);
    end;
% 
%     ii = ii+1;
%     if ii == 10
%         fprintf('.');
%         ii = 0;
%     end;
end;
