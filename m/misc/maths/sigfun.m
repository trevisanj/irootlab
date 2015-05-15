%>@ingroup maths
%>@file
%>@brief Sigmoid function
%>
%> @sa biocomparer
%
%> @param x argument (works with vectors and matrices as well
%> @param hh =45. "half-height". Defaults to 45 cm^{-1}
%> @param flag_demo If passed, will generate its own @c x (passed @c x will be ignored) and a figure 
function y = sigfun(x, hh, flag_demo)

s = 6;

if nargin < 2 || isempty(hh)
    hh = 45;
end;

if nargin > 2
    x = -1:.01:hh*2;
end;

y = (1+exp(-s))./(1+exp((x-hh)*s/hh));

if nargin > 2
    figure;
    plot(x, y);
    hold on;
    plot([hh, hh], [0, 1], 'r--');
    xlim([0, hh*2]);
    set(gca, 'xtick', [0, hh, hh*2]);
end;
    
    
    
