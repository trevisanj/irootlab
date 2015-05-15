%> @ingroup maths
%>@file
%>@brief Convex Polygonal Line baseline correction
%>
%> This was inspired on OPUS Rubberband baseline correction (RBBC) [1].
%>
%> Stretches a convex polygonal line whose vertices touch troughs of x
%> without crossing x (see below).
%>
%> This one is parameterless, whereas OPUS RBBC asks for a number of points.
%>
%> @image html rubberlike_explain.png
%>
%> <h3>References</h3>
%> ﻿[1] Bruker Optik GmbH, OPUS 5 Reference Manual. Ettlingen: Bruker, 2004.
%>
%> @sa demo_pre_bc_rubber.m
%
%> @param X [@ref no]x[@ref nf] matrix whose rows will be individually baseline-corrected
%>
%> @return @em [Y] or @em [Y, L] Where @em L are the baselines
function varargout = bc_rubber(X)

msgstring = nargoutchk(1, 2, nargout);
if ~isempty(msgstring)
    error(msgstring);
end;


[no, nf] = size(X);

Y = zeros(no, nf);
L = zeros(no, nf);

for i = 1:no
    if nf > 0
        l = [];
        x = X(i, :);
        if length(x) > 1
            l2 = rubber(x);
        else
            l2 = [];
        end;
        l = [x(1) l2];
        
        Y(i, :) = x-l;
        L(i, :) = l;
    end;
end;



if nargout == 1
    varargout = {Y};
elseif nargout == 2
    varargout = {Y, L};
end;
    
%> @cond
%---------------------------------------------------------------------
% returns a "rubber" vector with one element less than the length of x
function y = rubber(x)

nf = length(x); % number of points

l = linspace(x(1), x(end), nf);

xflat = x-l;
[val, idx] = min(xflat);
if ~isempty(val) && val < 0
    y = [rubber(x(1:idx)), rubber(x(idx:end))];
else
    y = l(2:end);
end;
%> @endcond
