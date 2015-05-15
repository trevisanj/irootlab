function [sn]=normv2(s)
% normalitzacio s=s/sqrt(sum(si)2))
[m,n]=size(s);
for i=1:m,
sr=sqrt(sum(s(i,:).*s(i,:)));
sn(i,:)=s(i,:)./sr;
end
end
