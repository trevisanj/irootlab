function [conc]=unimod(conc,rmod,cmod)

[ns,nc]=size(conc);

% 1) look for the maximum

for j=1:nc,
[y,imax(j)]=max(conc(:,j));
end

% 2) force unimodality shape

for j=1:nc,

rmax=conc(imax(j),j);
k=imax(j);
% disp('maximum at point');disp(k)

% 2a) discard left maxima (tolerance rmod)

while k>1,
k=k-1;

if conc(k,j)<=rmax,
	rmax=conc(k,j);
else,
	rmax2=rmax*rmod;
        if conc(k,j)>rmax2,
	
	% disp('no left unimodality in point: ');disp(k);
	% pause
       	
	if cmod==0,conc(k,j)=1.0E-30;end
       	if cmod==1,conc(k,j)=conc(k+1,j);end
	if cmod==2,
		if rmax>0,	
			conc(k,j)=(conc(k,j)+conc(k+1,j))/2;
			conc(k+1,j)=conc(k,j);
			k=k+2;
		else
			conc(k,j)=0;
		end
	end
	
	rmax=conc(k,j);

	end

end

end

% 2b) discard right maxima (tolerance rmod)

rmax=conc(imax(j),j);
k=imax(j);

while k<ns,
k=k+1;

if conc(k,j)<=rmax,
	rmax=conc(k,j);
else,
	rmax2=rmax*rmod;
        if conc(k,j)>rmax2,
        if cmod==0,conc(k,j)=1.0E-30;end
        if cmod==1,conc(k,j)=conc(k-1,j);end
 	if cmod==2,
		% disp('no right unimodality in point: ');
		% disp([k,conc(k,j),rmax])
		% disp('rmax= ');disp(rmax);
		% pause
		if rmax>0,
			conc(k,j)=(conc(k,j)+conc(k-1,j))/2;
			conc(k-1,j)=conc(k,j);
			k=k-2;
		else
			conc(k,j)=0;
		end
	end
        rmax=conc(k,j);
        end
end

end

end
