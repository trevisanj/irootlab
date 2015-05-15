function [e,eforward,ebackward]=efa(d,ns)
% function evolving factor analysis efa
% [e,eforward,ebackward]=efa(d,ns)
% d is the original data matrix
% ns is the number of rows of matrix d to be included in the efa analysis
% (this allows the application of efa to submatrices)
% e is the abstract concentration profiles built from the efa results
% eforward are the eigenvalues of the forward efa
% ebackward are the eigenvalues of backward efa

disp '% ***********************************************'
disp '% MATLAB program EFA (evolving factor analysis) *'
disp '% Group of Chemometrics and Solution Chemistry  *'
disp '% University of Barcelona                       *'
disp '% Department of Analytical Chemistry            *'
disp '% Diagonal 647, Barcelona 08028                 *'
disp '% e-mail equil@quimio.qui.ub.es                 *'
disp '% ***********************************************'

close all

x=d(1:ns,:);
[nsoln,nwave]=size(x);
minn=min(nsoln,nwave);

% ****************
% forward analysis
% ****************

disp('forward analysis')
n=2;
while n<=nsoln
disp('processing row number: '),disp(n)
svf=svd(x(1:n,:));
l=svf.*svf;
nl=size(l);


ef(1:nl,n-1)=l(1:nl,1);
efl(1:nl,n-1)=log10(l(1:nl,1));
n=n+1;
end
ef=ef';
efl=efl';
eforward=ef;

% set appropriately the zero log values
minvalue=min(min(efl));
minvalue=round(minvalue);
[ns1,ns2]=size(efl);
for i=1:ns1,
for j=1:ns2,
    if efl(i,j)==0,
    efl(i,j)=minvalue;
    end
end
end

xforward=[2:nsoln];
figure(1),subplot(2,1,1),plot(xforward,efl)
title('Forward EFA')
xlabel('Row number')
ylabel('log(eigenvalues)')

% *****************
% backward analysis
% *****************

disp('backward analysis')
x=x(nsoln:-1:1,:);
n=2;
while n<=nsoln
disp('processing row number (backward): '),disp(n)
svb=svd(x(1:n,:));
nl=size(svb);
l=svb.*svb;
eb(1:nl,n-1)=l(1:nl,1);
ebl(1:nl,n-1)=log10(l(1:nl,1));
n=n+1;
end
eb=eb';
ebl=ebl';
ebackward=eb;

% set appropriately the zero log values
minvalue=min(min(ebl));
minvalue=round(minvalue);
[ns1,ns2]=size(ebl);
for i=1:ns1,
for j=1:ns2,
    if ebl(i,j)==0,
    ebl(i,j)=minvalue;
    end
end
end

xbackward=[nsoln:-1:2];
figure(1),subplot(2,1,2),plot(xbackward,ebl)
title('Backward EFA')
xlabel('Row number')
ylabel('log(eigenvalues)')

disp('Press any key to see the combined EFA plot (forward + backward)')
pause

% ******************************
% evolving factor analysis plots
% ******************************

% 1) plot the log(eigenvalues) and singular values

xforward=[2:nsoln];
xbackward=[nsoln:-1:2];
hold off;

figure(2),subplot(2,1,1),plot(xforward,efl,'k',xbackward,ebl,'r')
title('EVOLVING FACTOR ANALYSIS')
xlabel('Row number')
ylabel('log(eigenvalues)')

figure(2),subplot(2,1,2),plot(xforward,sqrt(efl),'k',xbackward,sqrt(ebl),'r')
xlabel('Row number')
ylabel('Singular values')


% 2) rescaling the log of eigenvalues plot

disp('Press any key to select the min value of the log(eig) EFA plot')
pause
maxvalue=max(max(ebl));
maxvalue=round(maxvalue+1);
minvalue=input(' min. value of log efa plots ? ');
figure(3),plot(xforward,efl,'k',xbackward,ebl,'r')
axis([2 nsoln minvalue maxvalue])
title('EVOLVING FACTOR ANALYSIS')
xlabel('Row number')
ylabel('log(eigenvalues)')

disp('Press any key to build the initial estimates from EFA results')
pause

% 3) plot the arranged conc. profiles for the num. of factors

nf=input('Number of factors to be considered:? ');
nfdif ='y';

while nfdif == 'y' | nfdif == 'Y'

clear e;

for j=1:nf
    jj=nf+1-j;
for i=1:nsoln-1,
    ii=nsoln-i;
    if ef(i,j)<=eb(ii,jj),
    e(i,j)=ef(i,j);
    else,
    e(i,j)=eb(ii,jj);
    end
    if e(i,j)==0.0, e(i,j)=1.0e-30; end
end
end

disp('Press any key to plot the arranged and cleaned profiles')
pause
figure(4),plot(xforward,e)
title ('Initial estimates from EFA analysis')
pause

nfdif=input('Other num. of factors to be considered:? (y/n)','s');
if nfdif == 'y' | nfdif == 'Y'
nf = input('How many factors should be considered? ');
end
end

e(2:nsoln,:)=e(1:nsoln-1,:);
return
