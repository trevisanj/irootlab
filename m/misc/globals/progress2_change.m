%> @ingroup globals usercomm
%> @file
%> @brief Changes progress bar

%> @param prgrss Progress structure
%> @param perc=0 Percent
%> @param i=[] Iteration number
%> @param n=[] Number of iterations
%> @return prgrss
function prgrss = progress2_change(prgrss, title, perc, i, n)

if ~(nargin < 2 || isempty(title))
    prgrss.bars(1).title = title;
end;
if ~(nargin < 3 || isempty(perc))
    prgrss.bars(1).perc = perc;
end;
if ~(nargin < 4 || isempty(i))
    prgrss.bars(1).i = i;
end;
if ~(nargin < 5 || isempty(n))
    prgrss.bars(1).n = n;
end;

if isempty(prgrss.bars(1).tic_lastcall) ||  toc(prgrss.bars(1).tic_lastcall) > 11.59 % Minimum number of seconds between shows
    progress2_show(prgrss);
    prgrss.bars(1).tic_lastcall = tic();
end;

