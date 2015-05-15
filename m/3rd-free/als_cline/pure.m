function [sp,imp]=pure(d,nr,f)
% [sp,imp]=pure(d,nr,f)
% sp purest row/column profiles 
% imp indexes of purest variables
% d data matrix; nr (rank) number of pure components to search
% if d(nspectra,nwave) imp gives purest nwave => sp are conc. profiles (nr,nspectra)
% if d(nwave,nspectra) imp gives purest nspectra => sp are spectra profiles (nr,nwave)
% f percent of noise allowed respect maximum of the average spectrum given in % (i.e. 1% or 0.1%))

[nrow,ncol]=size(d);


% calculation of the purity spectrum

f=f/100;
s=std(d);
m=mean(d);
ll=s.*s+m.*m;
f=max(m)*f;
p=s./(m+f);


[mp,imp(1)]=max(p);

disp('first purest variable: ');disp(imp(1))

% calculation of the correlation matrix
% l=sqrt(m.*m+(s+f).*(s+f));

l=sqrt((s.*s+(m+f).*(m+f)));
% dl=d./(l'*ones(1,ncol));
for j=1:ncol,
dl(:,j)=d(:,j)./l(j);
end
c=(dl'*dl)./nrow;

% calculation of the weights
% first weight 

w(1,:)=ll./(l.*l);
p(1,:)=w(1,:).*p(1,:);
s(1,:)=w(1,:).*s(1,:);
figure(1)
subplot(3,1,1),plot(m)
title('unweigthed mean, std and first pure spectrum')
subplot(3,1,2),plot(s)
subplot(3,1,3),plot(p)

pause

% next weights


for i=2:nr,

for j=1:ncol,
[dm]=wmat(c,imp,i,j);
w(i,j)=det(dm);
p(i,j)=p(1,j).*w(i,j);
s(i,j)=s(1,j).*w(i,j);
end

% next purest and standard deviation spectrum

% plot(p(i,:))
% plot(s(i,:))
% title('sd and purest spectrum')
figure(i)
subplot(2,1,1),plot(p(i,:))
title('next pure spectrum and std dev. spectrum')
subplot(2,1,2),plot(s(i,:))
pause


[mp(i),imp(i)]=max(p(i,:));
disp('next purest variable: ');disp(imp(i))
end


for i=1:nr,
impi=imp(i);
sp(1:nrow,i)=d(1:nrow,impi);
end

figure(nr+1)
sp=normv2(sp');
plot(sp')

end
