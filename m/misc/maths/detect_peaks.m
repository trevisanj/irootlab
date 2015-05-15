%>@ingroup maths
%>@file
%> @brief Peak detector.
%>
%> This algorithm is a simplified version of [1]. What is referred to as "noise" in the publication can be considered as the @c minhei parameter.
%>
%> <h3>References</h3>
%> ﻿[1] K. R. Coombes et al., Quality control and peak finding for proteomics data collected from nipple aspirate fluid by surface-enhanced
%>     laser desorption and ionization.,” Clinical chemistry, vol. 49, no. 10, pp. 1615-23, Oct. 2003.
%>
%
%> @param y Vector of values.
%> @param minalt=0 Minimum altitude (distance from zero to montain top).
%> @param minhei=0 Minimum height (distance from highest foot (either left or right)) to mountain top.
%> @param mindist=1 Minimum horizontal distance between two peaks. Peak pruning based on this is done in an iterative
%> way to keep the highest peak of a set of peaks too close to each other.
%> @return Indexes of detected peaks
function idxs = detect_peaks(y, minalt, minhei, mindist)
if ~exist('mindist', 'var')
    mindist = 1;
end;
if ~exist('minalt', 'var')
    minalt = 0;
end;
if ~exist('minhei', 'var')
    minhei = 0;
end;

no_peaks = 0;
x_peaks = [];
y_peaks = [];


y = abs(y);
if sum(y == Inf) == length(y)
    y(y == Inf) = 0;
else
    y(y == Inf) = max(y(y ~= Inf));
end;
y = [0 y 0 Inf];


step = 1;
idxs = [0];
nf = length(y);

idx_foot1 = 1;
flag_maybe = 0;
flag_new = 0;
cnt0 = 0;
for i = 2:nf
    trend_ = y(i)-y(i-1);
    if trend_ == 0 && i > 2
        trend = trend_last;
        cnt0 = cnt0+1;
    else
        trend = trend_;
    end;
    
    if i > 2
        if trend == 0
        else
            if trend > 0 && trend_last < 0
                % new uptrend
                if flag_maybe
                    if y(idx_maybe)-y(i-1) > minhei
                        % last maximum will be a peak (unless not enough altitude, see below) because both feet are low
                        % enough (left foot already checked below).
                        flag_new = 1;
                        % right foot becomes left foot for next peak. Left foot is only re-assigned when a peak is found.
                        % It is reassigned regardless of the peak being at enough altitude.
                        idx_foot1 = i-1;
                    else
                        flag_maybe = 0; % last maximum found is not going to be a peak because right foot is too high
                    end;
                end;
            elseif trend < 0 && trend_last > 0
                % new downtrend
                if y(i-1)-y(idx_foot1) > minhei
                    idx_maybe = i-1-floor(cnt0/2);
                    flag_maybe = 1; % the previous point may be a peak
                end;
                cnt0 = 0;
            end;
        end;
    end;
    
    if flag_new
        if y(idx_maybe) >= minalt
            no_peaks = no_peaks+1;
            if no_peaks > step
                % efficient way to make idxs grow
                step = step*2;
                idxs(step) = 0;
            end;
            idxs(no_peaks) = idx_maybe;
        end;
        flag_new = 0;
    end;
    
    if trend_ ~= 0
        cnt0 = 0;
    end;
    
    trend_last = trend;
end;

idxs = idxs(1:no_peaks);



if mindist > 1
    %eliminates redundant peaks (too close to each other)
    
    while 1
        % idxs2(i) contains the distance between the i-th index and its predecessor
        % idid contains the indexes of the indexes of the peaks that need to be checked
        idxs2 = [Inf, diff(idxs)];
        idid = find(idxs2 < mindist);
        if numel(idid) == 0
            break;
        end;
        idid = union(idid, idid-1);
        
       
        % Peaks will be checked per block of adjacend peaks too close to each other
        flag_block = 0;
        for i = numel(idid):-1:1
            if idxs2(idid(i)) >= mindist
                if flag_block
                    i1 = i;
                    len = i2-i1+1;

                    [dummy, idxmax] = max(y(idxs(idid(i1:i2))));
                    % once maximum is found, it will engulf its left and right peaks
                    if idxmax < len
                        idxs(idid(i1-1+idxmax+1)) = [];
                    end;
                    if idxmax > 1
                        idxs(idid(i1-1+idxmax-1)) = [];
                    end;
                    
                    flag_block = 0;
                end;
            else
                if ~flag_block
                    flag_block = 1;
                    i2 = i;
                end;
            end;
        end;
    end;
end;
idxs = idxs-1; % A zero element has been added at the beginning, hence the "-1"
