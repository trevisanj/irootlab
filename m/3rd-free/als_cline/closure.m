function [conc]=closure(conc,iclos,sclos1,iclos1,tclos1,tclos2,sclos2,iclos2,vclos1,vclos2)
% function [conc]=closure(conc,iclos,sclos1,iclos1,tclos1,tclos2,sclos2,iclos2,vclos1,vclos2)
% closure is applied for a single experiment 
% vclos is a vectorial closure of the same size than conc
% closure types

[kfin,nspec]=size(conc);

% calculation of the total sums
% iclos,sclos1,iclos1,tclos1,tclos2,sclos2,iclos2,vclos1,vclos2,conc
summ1=zeros(size(conc,1),1);
summ2=zeros(size(conc,1),1);


for ns=1:nspec,
   if iclos ==1 | iclos==2,
      if sclos1(ns) == 1,
         summ1=summ1+conc(:,ns);
      end
   end
   if iclos==2,
      if sclos2(ns) == 1,
         summ2=summ2+conc(:,ns);
      end
   end
end
% check summ1 and summ2 not to be zero
izero=find(summ1==0);
summ1(izero)=ones(size(izero));
if iclos==2,
   izero=find(summ2==0);
   summ2(izero)=ones(size(izero));
end
maxsum1=max(summ1);
maxsum2=max(summ2);

% aplication of the different closure types

for ns=1:nspec,

% one closure condition

if iclos ==1 
   if iclos1 ==1 & sclos1(ns) == 1 & sclos2(ns) == 0	
      if isempty(vclos1)| vclos1==0
         conc(:,ns)=((conc(:,ns)*tclos1)./summ1);
      else
         conc(:,ns)=((conc(:,ns).*vclos1)./summ1);
      end
   end
   if iclos1 == 2 & sclos1(ns) ==1 & sclos2(ns) == 0
         if isempty(vclos1)| vclos1==0
      conc(:,ns)=((conc(:,ns)*tclos1)./maxsum1);
  else
      conc(:,ns)=((conc(:,ns).*vclos1)./maxsum1);
  end  
end
end


% two closure conditions

if iclos == 2
   if sclos1(ns)==1 & sclos2(ns)==1
      error ('One species is included in the two closures')
   end
   
% obeying first closure condition   
   if iclos1 ==1 & sclos1(ns) == 1 & sclos2(ns) == 0	
      if isempty(vclos1)| vclos1==0
         conc(:,ns)=((conc(:,ns)*tclos1)./summ1);
      else
         conc(:,ns)=((conc(:,ns).*vclos1)./summ1);
      end
   end
   if iclos1 == 2 & sclos1(ns) ==1 & sclos2(ns) == 0
        if isempty(vclos1)| vclos1==0
      conc(:,ns)=((conc(:,ns)*tclos1)./maxsum1);
        else
      conc(:,ns)=((conc(:,ns).*vclos1)./maxsum1);
        end  
    end
    
% obeying second closure condition
   if iclos1 ==1 & sclos1(ns) == 0 & sclos2(ns) == 1	
      if isempty(vclos2)| vclos2==0
         conc(:,ns)=((conc(:,ns)*tclos2)./summ2);
      else
         conc(:,ns)=((conc(:,ns).*vclos2)./summ2);
      end
   end
   if iclos1 == 2 & sclos1(ns) ==0 & sclos2(ns) == 1
      if isempty(vclos2)| vclos2==0
        conc(:,ns)=((conc(:,ns)*tclos2)./maxsum2);
      else
         conc(:,ns)=((conc(:,ns).*vclos2)./maxsum2);
      end  
   end  
   
end

%close for condition
end