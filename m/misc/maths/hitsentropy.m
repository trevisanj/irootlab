%>@ingroup maths
%> @file
%> @brief Calculates entropy curve of a hitss matrix
%>
%> @param hitss matrix [nf selected]x[nf] of "hits", where each row is a histogram in a forward selection process
%> @param type ='uni'
%>   @arg 'uni' evaluates the rows individually
%>   @arg 'accum' accumilates rows as it goes down the rows
%> @return y nf x stability curve
function y = hitsentropy(hitss, type)

if nargin < 2 || isempty(type)
    type = 'uni';
end;


[nf_select, nf] = size(hitss);

y = zeros(1, nf_select);

x = 0;
for i = 1:nf_select
    switch type
        case 'uni'
            x = hitss(i, :);
        case 'accum'
            x = hitss(i, :)+x;
        otherwise
            irerror(sprintf('Unknown type: "%s"', type));
    end;
    
    % converts to frequency or probability estimations
    p = x/sum(x);
    p(p == 0) = []; 
    
    y(i) = -sum(p.*log10(p));
end;
