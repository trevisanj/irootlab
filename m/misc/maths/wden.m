%>@ingroup maths
%>@file
%>@brief Wavelet De-noising
%>
%> This function uses MATLAB Wavelet toolbox swt() and wthresh() functions to de-noise the rows of X.
%> <h3>References</h3>
%> ﻿[1] M. Misiti, Y. Misiti, G. Oppenheim, and J.-M. Poggi, Wavelet Toolbox User’s Guide R2012b. Mathworks, 2012.
%
%> @param X
%> @param no_levels Number of times the signal will be decimated
%> @param thresholds Vector of thresholds, one value for each level. Thresholds are best determined by using the SWT denoising 1-D GUI tool from the Wavelet toolbox
%> @param waveletname examples: 'haar', 'db2', 'db3' (see Wavelet toolbox)
%> @return X
function X = wden(X, no_levels, thresholds, waveletname)

[no, nf] = size(X);

% Number of points of new signal needs to be determined the following way
% 1) Think about the number of levels: l
% 2) calculate ceil(nf/2^l)*2^l
%
% Example: for nf = 1336 and l = 6, this will give 1344
nfnew = ceil(nf/2^no_levels)*2^no_levels;
no_extend = ceil((nfnew-nf)/2);

ipro = progress2_open('Wavelet de-noising', [], 0, no);
for i = 1:no
    Xext = wextend(1, 'sym', X(i, :), no_extend, 'b');
    Xext = Xext(:, 1:nfnew); % In case nf was odd, Xext will have one column more


    % SWC contains the decompositions in rows: finest first, ..., then approximation
    % level 1
    SWC = swt(Xext, no_levels, waveletname);

    for j = 1:no_levels
        SWC(j, :) = wthresh(SWC(j, :), 'h', thresholds(no_levels+1-j));
    end;
    
    Xafter = iswt(SWC, waveletname);
    
    X(i, :) = Xafter(no_extend+1:no_extend+nf);

    
    ipro = progress2_change(ipro, [], [], i);
end;
progress2_close(ipro);
