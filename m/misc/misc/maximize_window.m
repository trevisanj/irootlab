%> @ingroup misc graphicsapi
%> @brief Maximizes figure on screen
%> @file
%>
%> Has a workaround to prevent figure from occupying two monitors, which
%> consists of dividing the width by two if the width-to-height ratio is
%> greater than 2.
%
%> @param h =gcf() Handle to figure.
%> @param aspectratio =1.618. If used, first making the image as big as possible, then reduce one of the dimensions to obbey 
%> <code>width/height = aspectratio</code>
%> @param normalizedsize =1. Multiplying factor for the calculated width and height
function maximize_window(h, aspectratio, normalizedsize)
if nargin < 1 || isempty(h)
    h = gcf();
end;

if nargin < 3 || isempty(normalizedsize)
    normalizedsize = 1;
end;

p = get(0,'Screensize'); % p(3) is width, and p(4) is height
p(3:4) = floor(p(3:4)*.99);

if p(3)/p(4) > 2.5
    % Likely to be picking the full double monitor screen size
    p(3) = floor(p(3)/2);
end;

if nargin >= 2 && ~isempty(aspectratio)
    ar_original = p(3)/p(4);
    arar = aspectratio/ar_original;
    
    if arar < 1
        p(3) = p(3)*arar;
    elseif arar > 1
        p(4) = p(4)/arar;
    end;
end;


p(3:4) = p(3:4)*normalizedsize;

figure(h);
set(h, 'Position', p);


