function wtvec = wtcheck(n, wtvec)

if ~isempty(wtvec)
    sizew = size(wtvec);
    if (length(sizew) > 1 && sizew(1) > 1 && sizew(2) > 1) || ...
            length(sizew) > 2
        error ('WTVEC must be a vector.');
    end
    if length(sizew) == 2 && sizew(1) == 1
        wtvec = wtvec';
    end
    if length(wtvec) ~= n
        error('WTVEC of wrong length');
    end
    if min(wtvec) <= 0
        error('All values of WTVEC must be positive.');
    end
else
    wtvec = ones(n,1);
end
