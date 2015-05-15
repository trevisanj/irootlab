function [h,p,ci,stats] = ttest(x,m,alpha,tail,dim)
%TTEST  One-sample and paired-sample t-test.
%   H = TTEST(X) performs a t-test of the hypothesis that the data in the
%   vector X come from a distribution with mean zero, and returns the
%   result of the test in H.  H=0 indicates that the null hypothesis
%   ("mean is zero") cannot be rejected at the 5% significance level.  H=1
%   indicates that the null hypothesis can be rejected at the 5% level.
%   The data are assumed to come from a normal distribution with unknown
%   variance.
%
%   X can also be a matrix or an N-D array.   For matrices, TTEST performs
%   separate t-tests along each column of X, and returns a vector of
%   results.  For N-D arrays, TTEST works along the first non-singleton
%   dimension of X.
%
%   TTEST treats NaNs as missing values, and ignores them.
%
%   H = TTEST(X,M) performs a t-test of the hypothesis that the data in
%   X come from a distribution with mean M.  M must be a scalar.
%
%   H = TTEST(X,Y) performs a paired t-test of the hypothesis that two
%   matched samples, in the vectors X and Y, come from distributions with
%   equal means. The difference X-Y is assumed to come from a normal
%   distribution with unknown variance.  X and Y must have the same length.
%   X and Y can also be matrices or N-D arrays of the same size.
%
%   H = TTEST(...,ALPHA) performs the test at the significance level
%   (100*ALPHA)%.  ALPHA must be a scalar.
%
%   H = TTEST(...,TAIL) performs the test against the alternative
%   hypothesis specified by TAIL:
%       'both'  -- "mean is not zero (or M)" (two-tailed test)
%       'right' -- "mean is greater than zero (or M)" (right-tailed test)
%       'left'  -- "mean is less than zero (or M)" (left-tailed test)
%   TAIL must be a single string.
%
%   [H,P] = TTEST(...) returns the p-value, i.e., the probability of
%   observing the given result, or one more extreme, by chance if the null
%   hypothesis is true.  Small values of P cast doubt on the validity of
%   the null hypothesis.
%
%   [H,P,CI] = TTEST(...) returns a 100*(1-ALPHA)% confidence interval for
%   the true mean of X, or of X-Y for a paired test.
%
%   [H,P,CI,STATS] = TTEST(...) returns a structure with the following fields:
%      'tstat' -- the value of the test statistic
%      'df'    -- the degrees of freedom of the test
%      'sd'    -- the estimated population standard deviation.  For a
%                 paired test, this is the std. dev. of X-Y.
%
%   [...] = TTEST(X,M,ALPHA,TAIL,DIM) or TTEST(X,Y,ALPHA,TAIL,DIM) works
%   along dimension DIM of X, or of X and Y.  Pass in [] to use default
%   values for M, Y, ALPHA, or TAIL.
%
%   See also TTEST2, ZTEST, SIGNTEST, SIGNRANK, VARTEST.

%   References:
%      [1] E. Kreyszig, "Introductory Mathematical Statistics",
%      John Wiley, 1970, page 206.

%   Copyright 1993-2010 The MathWorks, Inc.
%   $Revision: 1.1.6.3 $  $Date: 2010/10/08 17:26:58 $

if nargin < 2 || isempty(m)
    m = 0;
elseif ~isscalar(m) % paired t-test
    if ~isequal(size(m),size(x))
        error(message('stats:ttest:InputSizeMismatch'));
    end
    x = x - m;
    m = 0;
end

if nargin < 3 || isempty(alpha)
    alpha = 0.05;
elseif ~isscalar(alpha) || alpha <= 0 || alpha >= 1
    error(message('stats:ttest:BadAlpha'));
end

if nargin < 4 || isempty(tail)
    tail = 0;
elseif ischar(tail) && (size(tail,1)==1)
    tail = find(strncmpi(tail,{'left','both','right'},length(tail))) - 2;
end
if ~isscalar(tail) || ~isnumeric(tail)
    error('stats:ttest:BadTail', ...
          'TAIL must be one of the strings ''both'', ''right'', or ''left''.');
end

if nargin < 5 || isempty(dim)
    % Figure out which dimension mean will work along
    dim = find(size(x) ~= 1, 1);
    if isempty(dim), dim = 1; end
end

nans = isnan(x);
if any(nans(:))
    samplesize = sum(~nans,dim);
else
    samplesize = size(x,dim); % a scalar, => a scalar call to tinv
end
df = max(samplesize - 1,0);
xmean = nanmean(x,dim);
sdpop = nanstd(x,[],dim);
ser = sdpop ./ sqrt(samplesize);
tval = (xmean - m) ./ ser;
if nargout > 3
    stats = struct('tstat', tval, 'df', cast(df,class(tval)), 'sd', sdpop);
    if isscalar(df) && ~isscalar(tval)
        stats.df = repmat(stats.df,size(tval));
    end
end

% Compute the correct p-value for the test, and confidence intervals
% if requested.
if tail == 0 % two-tailed test
    p = 2 * tcdf(-abs(tval), df);
    if nargout > 2
        crit = tinv((1 - alpha / 2), df) .* ser;
        ci = cat(dim, xmean - crit, xmean + crit);
    end
elseif tail == 1 % right one-tailed test
    p = tcdf(-tval, df);
    if nargout > 2
        crit = tinv(1 - alpha, df) .* ser;
        ci = cat(dim, xmean - crit, Inf(size(p)));
    end
elseif tail == -1 % left one-tailed test
    p = tcdf(tval, df);
    if nargout > 2
        crit = tinv(1 - alpha, df) .* ser;
        ci = cat(dim, -Inf(size(p)), xmean + crit);
    end
else
    error('stats:ttest:BadTail',...
          'TAIL must be ''both'', ''right'', or ''left'', or 0, 1, or -1.');
end
% Determine if the actual significance exceeds the desired significance
h = cast(p <= alpha, class(p));
h(isnan(p)) = NaN; % p==NaN => neither <= alpha nor > alpha
