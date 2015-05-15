function [y, ncurve, nvar, ndim] = ycheck(y, n)

%  check Y

if ~strcmp(class(y), 'double')
    error('Y is not of class double.');
end

ydim = size(y);
if length(ydim) == 2 && ydim(1) == 1
    y = y';
end

ydim = size(y);  %  number of observations
if ydim(1) ~= n
    error('Y is not the same length as ARGVALS.');
end

%  set number of curves and number of variables

sizey = size(y);
ndim  = length(sizey);
switch ndim
    case 1
        ncurve = 1;
        nvar   = 1;
    case 2
        ncurve = sizey(2);
        nvar   = 1;
    case 3
        ncurve = sizey(2);
        nvar   = sizey(3);
    otherwise
        error('Second argument must not have more than 3 dimensions');
end



