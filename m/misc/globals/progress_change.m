%> @ingroup globals usercomm
%> @file
%> @brief Changes progress bar

%> @param idx Bar index
%> @param perc=0 Percent
%> @param i=[] Iteration number
%> @param n=[] Number of iterations
function idx = progress_change(idx, title, perc, i, n)
progress_assert();
global PROGRESS;

if ~(nargin < 2 || isempty(title))
    PROGRESS.bars(idx).title = title;
end;
if ~(nargin < 3 || isempty(perc))
    PROGRESS.bars(idx).perc = perc;
end;
if ~(nargin < 4 || isempty(i))
    PROGRESS.bars(idx).i = i;
end;
if ~(nargin < 5 || isempty(n))
    PROGRESS.bars(idx).n = n;
end;

if isempty(PROGRESS.bars(idx).tic_lastcall) ||  toc(PROGRESS.bars(idx).tic_lastcall) > 11.59 % Minimum number of seconds between shows
    progress_show();
    PROGRESS.bars(idx).tic_lastcall = tic();
end;

