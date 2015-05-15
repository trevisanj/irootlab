function [c,t]=trilin(c,ne,ishape)
%function [c,t]=trilin(c,ne,ishape)
% forces the shapes of the profiles to be equal
% estimates the ratios between the intensity of the profiles
% c input-output unfolded profiles
% ne number of experiments considered


[nst,nsign]=size(c);
ns=nst/ne;
ni=1;
nf=ns;

% folds the unfolded profiles in a matrix
% assumes there is sinchronization

for j=1:ne,
cp(1:ns,j)=c(ni:nf,nsign);
ni=nf+1;
nf=ni+ns-1;
end
y=cp;

% ****************************************************
% ishape=2 !!!!
% there is peak shifting, matching the peak maxima
% looks for maxima (ymax) and positions (imax)
% ****************************************************

if ishape==2,
[ymax,imax]=max(cp);

% looks for the minimum maximum (ymin)
% and takes it as a reference(imin)

imin=1;
ymin=imax(1);

for i=2:ne,
if imax(i)<ymin & ymax(i)>0,
imin=i;
ymin=imax(i);
end

end

for j=1:ne,

if j~=imin & ymax(j)>0,

ishift=imax(j)-ymin;

if ishift~=0,
y(1:ns-ishift,j)=cp(1+ishift:ns,j);
y(ns-ishift+1:ns,j)=zeros(ishift,1);
else,
y(:,j)=cp(:,j);
end

else,
y(:,j)=cp(:,j);
end

end
end
% **********************************************************
% this is for ishape = 1 or 2
% svd of the profile matrix
% **********************************************************

[u,s,v]=svd(y,0);

% estimates the total concentrations
t=s(1,1).*v(:,1)';

% calculates the new profiles
cp2=u(:,1)*t;
y=cp2;

% **********************************************************
% this is only for ishape=2
% breaks the matching of peaks to original positions
% **********************************************************

if ishape==2,
for j=1:ne,
if j~=imin & ymax(j)>0,
ishift=imax(j)-ymin;
if ishift~=0,
y(1:ishift,j)=zeros(ishift,1);
y(ishift+1:ns,j)=cp2(1:ns-ishift,j);
else,
y(:,j)=cp2(:,j);
end

else,
y(:,j)=cp2(:,j);
end
end
end
% ************************************************************
% plot(y)
% pause

% unfolds the profiles
ni=1;
nf=ns;
for j=1:ne,
c(ni:nf,nsign)=y(1:ns,j);
ni=nf+1;
nf=ni+ns-1;
end


% calculates the differences
rs=cp-y;
u=sum(sum(rs*rs'));
sigma=sqrt(u/(nst));
% disp('std. dev. res. between the estimations');disp(sigma);
% disp('singular values ');disp([s(1,1);s(2,2)]);
% disp('estimates of the total concentrations are: '),disp(t);
% pause
end

