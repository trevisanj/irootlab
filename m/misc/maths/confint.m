%> @brief Calculates confidence interval
%> @ingroup maths
%> @file
%>
%> @brief Calculates confidence interval of an input vector
%
%> @param x Input vector
%> @param perc =.95 The percentual confidence
%> @return a 2-element vector with the confidence interval boundaries
function y = confint(x, perc)

if nargin < 2 || isempty(perc)
    perc = .95;
end;

me = mean(x);
st = std(x);
n = numel(x);

perc2 = 1-(1-perc)/2;  % Adujsts to single-tail


no_stds = tinv(perc2, n-1);
mean_std = st/sqrt(n);
n1 = me-mean_std*no_stds;
n2 = me+mean_std*no_stds;

y = [n1, n2];