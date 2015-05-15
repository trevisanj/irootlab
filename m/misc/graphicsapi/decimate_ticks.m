%>@ingroup graphicsapi
%>@file
%>@brief Removes ticks when there are too many of them
%
%> @param flags =[1, 1]. Corresponds to [flag_x, flag_y], i.e., whether to act on the respective axis's
%> @param maxs =[16, 13]. Maximum numbers of ticks in the x-axis and y-axis respectively
function decimate_ticks(flags, maxs)

if nargin < 1 || isempty(flags)
    flags = [1, 1];
elseif numel(flags) == 1
    flags = [flags, 0]; % when only one flag is passed, the y-axis one will be turned off by default
end;

if nargin < 2 || isempty(maxs)
    maxs = [16, 13];
elseif numel(maxs) == 1
    maxs = [maxs, 0]; % when only one flag is passed, the y-axis one will be turned off by default
end;

xy = 'xy';
h_ca = gca();
for i = 1:2
    if flags(i)
        maxticks = maxs(i);
        stn = xy(i); % string, tick name
        
        ticks = get(h_ca, [stn, 'tick']);
        nf = numel(ticks);

        no_ins = nf/maxticks; 
        if no_ins > 1
            ii = round(linspace(1, nf, maxticks));

            ticklabels = get(h_ca, [stn, 'ticklabel']);
            ticklabels = ticklabels(ii);
            ticks = ticks(ii);
            
            set(h_ca, [stn, 'tick'], ticks);
            set(h_ca, [stn, 'ticklabel'], ticklabels);
        end;
    end;
end;