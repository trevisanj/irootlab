%> @ingroup globals usercomm
%> @file
%> @brief Opens new progress bar

%> @param title='' Title
%> @param perc=0 Percent
%> @param i=[] Iteration number
%> @param n=[] Number of iterations
function idx = progress_open(title, perc, i, n)
progress_assert();

if nargin < 1 || isempty(title)
    title = [];
end;
if nargin < 2 || isempty(perc)
    perc = [];
end;
if nargin < 3 || isempty(i)
    i = [];
end;
if nargin < 4 || isempty(n)
    n = [];
end;

global PROGRESS;
PROGRESS.bars(end+1).title = title;
PROGRESS.bars(end).perc = perc;
PROGRESS.bars(end).i = i;
PROGRESS.bars(end).n = n;
PROGRESS.bars(end).tic = tic();
PROGRESS.bars(end).tic_lastcall = [];

idx = numel(PROGRESS.bars);

progress_show();
