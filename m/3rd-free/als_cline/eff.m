function efeig=eff(d,ws,nr)
% function efeig=eff(d,ws,nr)
% function fixed size moving window evolving factor analysis
% d is the data matrix, ws is the fixed size of the moving window
% nr is the number of rows to be considered of the d matrix
% efeig results of FSMW-EFA (eigenvalue scale)

disp '% ***********************************************'
disp '% MATLAB program EFF (evolving factor analysis  *'
disp '% with a fixed size moving window)              *'
disp '% written by Roma Tauler and Anna de Juan, 2002 *'
disp '% University of Barcelona                       *'
disp '% Department of Analytical Chemistry            *'
disp '% Diagonal 647, Barcelona 08028                 *'
disp '% e-mail roma@apolo.qui.ub.es                   *'
disp '% ***********************************************'

close all
clear efeig;
d=d(1:nr,:);
[nsoln,nwave]=size(d);
minn=min(nsoln,nwave);

i=1;
n=ws-1;

while i<=nsoln-n
% build fixed size matrix
x=d(i:i+n,:);
% disp('processing window number: '),disp(i)
sv=svd(x);
inum=size(sv);
for k=1:inum,if sv(k)==0, sv(k)=sv(k-1); end, end
l=sv.*sv;
ef(1:n+1,i)=sv(1:n+1,1);
efeig(1:n+1,i)=l(1:n+1,1);
efl(1:n+1,i)=log10(l(1:n+1,1));
i=i+1;
end
ef=ef';
efeig=efeig';
efl=efl';

% set appropiately the zero log values
minvalue=min(min(efl));
minvalue=round(minvalue)-0.1*abs(round(minvalue));
[ns1,ns2]=size(efl);
for i=1:ns1,
for j=1:ns2,
    if efl(i,j)==0,
    efl(i,j)=minvalue;
    end
end
end


% FSMW-EFA
% 1) plot of singular values
xforward=[1:nsoln-n];
disp('Press any key to see the FSMW-EFA plot')
pause
figure(1),plot(xforward,ef)
title(['FSMW-EFA. Window size ' num2str(ws)])
xlabel('Row number')
ylabel('Singular values')
pause

% 2) plot of log(eigenvalues)
maxvalue=max(max(efl));
maxvalue=round(maxvalue+1);
minvalue=minvalue;
nwindows=nsoln-n;
disp('Press any key to plot FSMW-EFA log(eigenvalues) results')
pause
figure(2),
v=[1,nwindows,minvalue,maxvalue];
axis(v);
plot(xforward,efl)
title(['FSMW-EFA. Window size ' num2str(ws)])
xlabel('Row number')
ylabel('log(eigenvalues)')

