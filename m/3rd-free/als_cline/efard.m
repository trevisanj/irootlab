function [efullrank,effullrank,ebfullrank,erd,efrd,ebrd]=efard(d,nmat,nrow,frank)
% function evolving factor analysis for rank-deficient matrices.
% function [efullrank,effullrank,ebfullrank,erd,efrd,ebrd]=efard(d,nmat,nrow,frank)
% d is the original column-wise augmented data set (containing one or more full-rank 
% matrices on top and one rank-deficient matrix below) 
% nmat is the total number of matrices appended in the column-wise augmented data set
% nrow is sized (1 x nmat) and contains the number of rows of each matrix in d.
% frank is sized (1 x nmat) and tells whether each matrix in the data set is full-rank (1) or rank-deficient (0)
% efullrank contain the abstract concentration profiles for the full rank matrix. When there 
% is more than one full-rank matrix, efullrank is a cell array with as many elements as full-rank matrices. 
% effullrank are the eigenvalues of the forward efa for the full-rank matrices. When there 
% is more than one full-rank matrix, effullrank is a cell array with as many elements as full-rank matrices. 
% ebfullrank are the eigenvalues of backward efa for the full-rank matrices. When there 
% is more than one full-rank matrix, ebfullrank is a cell array with as many elements as full-rank matrices.
% erd are the initial estimates for the contributions in the rank-deficient matrix that are absent in the appended full-rank matrices.
% efrd are the eigenvalues of the forward efa for the new contributions in the rank-deficient matrix.
% ebrd are the eigenvalues of backward efa for the new contributions in the rank-deficient matrix.

disp '% ***********************************************'
disp '% MATLAB program EFA (evolving factor analysis) *'
disp '% Group of Chemometrics and Solution Chemistry  *'
disp '% University of Barcelona                       *'
disp '% Department of Analytical Chemistry            *'
disp '% Diagonal 647, Barcelona 08028                 *'
disp '% e-mail equil@quimio.qui.ub.es                 *'
disp '% ***********************************************'

close all


[nrd,ncd]=size(d);
if sum(nrow)~=nrd
    error('The dimensions in nrow do not match the size of the data set d')
end
if size(nrow,2)~=nmat | size(frank,2)~=nmat
    error('nrow or frank are not input as a row with as many elements as data matrices')
end


for k=1:nmat

%*******************************************
% EFA for full-rank matrices in the data set
%*******************************************
    
    if frank(k)==1
        df=d(nrd-sum(nrow(k:nmat)')+1:sum(nrow(1:k)),:);
        [efullrank{1,k},effullrank{1,k},ebfullrank{1,k}]=efa(df,nrow(k));
    end

%******************************************************************************************
% EFA for the rank-deficient matrix (looking for contributions absent in full-rank matrices
% *****************************************************************************************
        
        if frank(k)==0

% Forward EFA for the column-wise augmented data set
% **************************************************


disp('Forward analysis for the column-wise augmented data set')
n=2;
while n<=nrd
%disp('processing row number: '),disp(n)
svf=svd(d(1:n,:));
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

xforward=[2:nrd];
maxvalue=max(max(efl));
maxvalue=round(maxvalue);
figure,subplot(1,2,1),plot(xforward,efl,'k')
title('Forward EFA 3-way data')
xlabel('Row number')
ylabel('log(eigenvalues)')
xline=nrd-nrow(k)+1;
line([xline xline],[minvalue maxvalue])
set(line([xline xline],[minvalue maxvalue]),'Color','black')

subplot(1,2,2),plot(xforward,sqrt(ef),'k')
title('Forward EFA 3-way data')
xlabel('Row number')
ylabel('Singular values')
xline=nrd-nrow(k)+1;
svminvalue=min(min(sqrt(ef)));
svminvalue=round(svminvalue);
svmaxvalue=max(max(sqrt(ef)));
svmaxvalue=round(svmaxvalue);
line([xline xline],[svminvalue svmaxvalue])
set(line([xline xline],[svminvalue svmaxvalue]),'Color','black')
pause
disp('Press any key to continue')

% 'Backward' EFA for the column-wise augmented data set
% *****************************************************

df=d(nrd-nrow(k)+1:nrd,:);
db=[df;d(1:sum(nrow(1:k-1)),:)];

db=flipud(db);


n=2;
while n<=nrd
svb=svd(db(1:n,:));
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

xbackward=[nrd:-1:2];
maxvalue=max(max(ebl));
maxvalue=round(maxvalue);
figure,subplot(1,2,1),plot(xbackward,ebl,'k--')
title('Backward EFA 3-way data')
xlabel('Row number')
ylabel('log(eigenvalues)')
xline=nrd-nrow(k)+1;
line([xline xline],[minvalue maxvalue])
set(line([xline xline],[minvalue maxvalue]),'Color','black')

subplot(1,2,2),plot(xbackward,sqrt(eb),'k--')
title('Backward EFA 3-way data')
xlabel('Row number')
ylabel('Singular values')
xline=nrd-nrow(k)+1;
svminvalue=min(min(sqrt(eb)));
svminvalue=round(svminvalue);
svmaxvalue=max(max(sqrt(eb)));
svmaxvalue=round(svmaxvalue);
line([xline xline],[svminvalue svmaxvalue])
set(line([xline xline],[svminvalue svmaxvalue]),'Color','black')
pause 
disp('Press any key to continue')




% ***********************************************************
% evolving factor analysis plot for the rank-deficient system
% ***********************************************************

% Deleting number of contributions present in full-rank matrices

ncompfd=input('Total number of components in full-rank matrices?  ');  

xforwardrd=[1:nrow(k)];
xbackwardrd=[nrow(k):-1:1];
hold off;

[x,y]=size(efl);

eflrd=efl(nrd-nrow(k):nrd-1,ncompfd+1:y);
eblrd=ebl(nrd-nrow(k):nrd-1,ncompfd+1:y);

efrd=ef(nrd-nrow(k):nrd-1,ncompfd+1:y);
ebrd=eb(nrd-nrow(k):nrd-1,ncompfd+1:y);

figure,subplot(2,1,1),plot(xforwardrd,eflrd,'k',xbackwardrd,eblrd,'k--')
title('EVOLVING FACTOR ANALYSIS RANK-DEFICIENT CONTRIBUTIONS')
xlabel('Row number')
ylabel('log(eigenvalues)')

subplot(2,1,2),plot(xforwardrd,sqrt(efrd),'k',xbackwardrd,sqrt(ebrd),'k--')
xlabel('Row number')
ylabel('Singular values')


% 2) rescaling the log of eigenvalues plot

disp('Press any key to select the min value of the log(eig) EFA plot')
pause
maxvalue=max(max(eblrd));
maxvalue=round(maxvalue+1);
minvalue=input(' min. value of log efa plots ? ');
figure,plot(xforwardrd,eflrd,'k',xbackwardrd,eblrd,'k--')
axis([1 nrow(k) minvalue maxvalue])
title('EVOLVING FACTOR ANALYSIS')
xlabel('Row number')
ylabel('log(eigenvalues)')

disp('Press any key to build the initial estimates from EFA results')
pause

% 3) plot the arranged conc. profiles for the num. of factors

nf=input('Number of factors to be considered:? ');
nfdif ='y';

while nfdif == 'y' | nfdif == 'Y'

clear erd;

ebudrd=flipud(ebrd);
for j=1:nf
    jj=nf+1-j;
for i=1:nrow(k)
    ii=i;
    if efrd(i,j)<=ebudrd(ii,jj),
    erd(i,j)=efrd(i,j);
    else,
    erd(i,j)=ebudrd(ii,jj);
    end
    if erd(i,j)==0.0, erd(i,j)=1.0e-30; end
end
end
erd=sqrt(erd);

disp('Press any key to plot the arranged and cleaned profiles')
pause
figure,plot(xforwardrd,erd)
title ('Initial estimates from EFA analysis for new contributions in rank-deficient matrix')
pause

nfdif=input('Other num. of factors to be considered:? (y/n)','s');
if nfdif == 'y' | nfdif == 'Y'
nf = input('How many factors should be considered? ');
end
end

return

end
end
