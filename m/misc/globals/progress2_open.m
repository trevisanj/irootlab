%> @ingroup globals usercomm
%> @file
%> @brief Creates progress bar.
%>
%> This version does not use globals
%
%> @param title='' Title
%> @param perc=0 Percent
%> @param i=[] Iteration number
%> @param n=[] Number of iterations
%> @return prgrss
function prgrss = progress2_open(title, perc, i, n)

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

prgrss.bars(1).title = title;
prgrss.bars(1).perc = perc;
prgrss.bars(1).i = i;
prgrss.bars(1).n = n;
prgrss.bars(1).tic = tic();
prgrss.bars(1).tic_lastcall = [];
prgrss.bars(1).sid = sprintf('P#%04d', floor(rand(1, 1)*9999));

progress2_show(prgrss);
