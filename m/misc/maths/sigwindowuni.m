%>@ingroup maths
%>@file
%>@brief Point-by-point multiplications of the rows of X by a sigmoid
%>
%> @sa pre_sigwindow
%
%> @param X matrix with curves as rows
%> @param idxcentre index where sigmoid will be 0.5
%> @param scale length for sigmoid to go from 0.5 to .995 or .005
%> @return X
function X = sigwindowuni(X, idxcentre, scale)

% 1/(1+exp(-k*scale)) = .995 ==> % k*scale = -log(.005)
k = -log(.005)/scale;

sigvalues = (1./(1+exp(-k*((1:size(X, 2))-idxcentre))));
X = X.*repmat(sigvalues, size(X, 1), 1);



