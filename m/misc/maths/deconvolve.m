%>@ingroup maths
%>@file
%>@brief Deconvolution with a vector h
%>
%> There are two possible ways to use this function:
%>@code
%>[X_after] = deconvolve(X, [], h)
%>@endcode
%>or
%>@code
%>[X_after, x_after] = deconvolve(X, x, h)
%>@endcode
%>
%> The number of variables of the output will be <code>nf_input-2*(length(h)-1)/2</code>
%>
%> h needs to be an odd-length vector.
%
%> @param X
%> @param x
%> @param h
%>@return <code>[X_after]</code> or <code>[X_after, x_after]</code>, as described above.
function varargout = deconvolve(X, x, h)

if length(h)/2 == floor(length(h)/2)
    error('Odd-length filter, please!');
end;

flag_x = ~isempty(x);

h = h/norm(h); % makes filter norm unitary

offset = (length(h)-1)/2;

[no, nf] = size(X);
X_after = zeros(no, nf-2*offset);

for i = 1:no
    X_after(i, :) = deconv(X(i, :), h);
end;

if ~flag_x
    varargout = {X_after};
else
    x_after = x(1+offset:end-offset);
    varargout = {X_after, x_after};
end;

