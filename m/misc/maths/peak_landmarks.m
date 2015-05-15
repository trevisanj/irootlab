%>@ingroup maths
%>@file
%>@brief Converts curves to their peaks/troughs locations
%>
%> @param X data matrix with curves as rows
%> @param map <code>[idxmin, idxmax, flag_min; ...]</code>
%> @param t_range for the final conversion of output values to the proper scale.
%> @return T
function T = peak_landmarks(X, map, t_range)

[no, no_t] = size(X);

if ~exist('t_range', 'var')
    t_range = [1, no_t];
end;


no_peaks = size(map, 1);
T = zeros(no, no_peaks);
for i = 1:no
    v = X(i, :);
    
    for j = 1:no_peaks
        idxs = map(j, 1):map(j, 2);
        flag_min = map(j, 3);
        
        if flag_min
            [val, idx_peak] = min(v(idxs));
        else
            [val, idx_peak] = max(v(idxs));
        end;
        idx_peak = idx_peak+idxs(1)-1;
        
        T(i, j) = idx_peak;
    end;
end;
    
tf = t_range(2);
ti = t_range(1);

T = (T-1)*(tf-ti)/(no_t-1)+ti; % Normalizes warping information to the original number of features
