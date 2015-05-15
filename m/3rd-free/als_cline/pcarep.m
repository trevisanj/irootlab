function [u,s,v,x,sigma]=pcarep(xi,nf)
% function [u,s,v,x,sigma]=pcarep(xi,nf)
% PCA reproduction of the original data matrix x dor nf components
% u,s,v and x as in svd matlab function [u,s,v]=svd(x)
% xi is the original input data matrix (with noise)
% x is the pca reproduced data matrix (filtered no noise)
% nf is the number of components to be included in the reproduction

t0=cputime;

[u,s,v]=svd(xi,0);
u=u(:,1:nf);
s=s(1:nf,1:nf);
v=v(:,1:nf);
x=u*s*v';
res=xi-x;
sst1=sum(sum(res.*res));
sst2=sum(sum(xi.*xi));
sigma=(sqrt(sst1/sst2))*100;
disp(['PCA CPU time: ',num2str(cputime-t0)]);
disp(['Number of conmponents: ',num2str(nf)]);
disp(['percent of lack of fit (PCA lof): ',num2str(sigma)]);



