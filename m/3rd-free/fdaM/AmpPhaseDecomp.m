function [MS_amp, MS_pha, RSQR, C] = AmpPhaseDecomp(xfd, yfd, wfd)
%  Computes the amplitude-phase decomposition for a registration.

%  Arguments:
%  XFD  ...  FD object for unregistered functions
%  YFD  ...  FD object for registered functions
%  Wfd  ...  FD object for W functions determining warping functions

%  Returns:
%  MS_amp ... mean square for amplitude variation 
%  MS_pha ... mean square for amplitude variation 
%  RSQR   ... squared correlation measure of prop. phase variation 
%  C      ... constant C

%  Last modified 19 January 2009

xbasis  = getbasis(xfd);
nxbasis = getnbasis(xbasis);
nfine   = 10*nxbasis;
xrng    = getbasisrange(xbasis);
tfine   = linspace(xrng(1),xrng(2),nfine)';
delta   = tfine(2)-tfine(1);

wfine   = eval_fd(tfine, wfd);
xfine   = eval_fd(tfine, xfd);
yfine   = eval_fd(tfine, yfd);
efine   = exp(wfine);

mufine  = mean(xfine,2);
etafine = mean(yfine,2);
N = size(xfine,2);
rfine   = yfine - etafine*ones(1,N);

intetasqr = delta.*trapz(etafine.^2);
intmusqr  = delta.*trapz(mufine.^2);

Cnum = zeros(nfine,1);
for i=1:nfine
    Dhi = efine(i,:)';
    Syi = (yfine(i,:)').^2;
    Covmat = cov(Dhi, Syi);    
    Cnum(i) = Covmat(1,2);
end
intCnum = delta.*trapz(Cnum);
intysqr = zeros(N,1);
intrsqr = zeros(N,1);
for i=1:N
    intysqr(i) = delta.*trapz(yfine(:,i).^2);
    intrsqr(i) = delta.*trapz(rfine(:,i).^2);
end
C = 1 + intCnum/mean(intysqr);
MS_amp = C*mean(intrsqr);
MS_pha = C*intetasqr - intmusqr;
RSQR = MS_pha/(MS_amp+MS_pha);
