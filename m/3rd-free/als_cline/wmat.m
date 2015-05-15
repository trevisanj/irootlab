function [dm]=wmat(c,imp,irank,jvar)
dm(1,1)=c(jvar,jvar);
for k=2:irank,
kvar=imp(k-1);
dm(1,k)=c(jvar,kvar);
dm(k,1)=c(kvar,jvar);
for kk=2:irank,
kkvar=imp(kk-1);
dm(k,kk)=c(kvar,kkvar);
end
end
end
