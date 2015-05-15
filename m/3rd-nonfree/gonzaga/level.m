function [H]=level(func,x0,dxmax,col,precision,kmax);
%  function H=level(func,x0,dxmax,col,precision,kmax);
%  Clovis Caesar Gonzaga (clovis@mtm.ufsc.br), 6-dec-1999.
%       traces a level curve for objetive through x0.
%       The curve closes (result=1) or
%       k reaches kmax or |x-x0|>dxmax componentwise (result 0).
%  Normal call: result=level(func,x0,dxmax)
% col is a color letter, default 'r'.
% if precision is zero or  not given, precision=1 is used.
% ----> normal precision is 1. High precision: precision=10. 
% ----> low precision: precision in the interval 0.1,1.
% if kmax is not given, uses kmax=500.
%
% Returns a cell of handles for the newly created graphic objects.
H = {};
iPlot = 0;
   if length(x0)>2, disp('dimension is not 2: no plots'); return; end;
   if exist('precision')==0, precision=1; end;
   if precision==0, precision=1; end;
   if precision<0.1, 
         disp('precision is too low: must be better than 0.1');
         exit;
   end;
   precision = 100*precision;
   if exist('kmax')==0, kmax=500; end;
   if exist('col')==0, col='r'; end;
% not necessary   col=[col '-'];
done=0;
direction=1;
result = 0;
while done==0;
   if direction==-1, done=1; end; %this is the second pass.
   xk=zeros(2,kmax);
   x=x0;
   f0=feval(func,x0, 0);
   fx=f0;
   g0=feval(func,x0,1);
   k=1;
   xk(:,k)=x;
   dxmax10=dxmax/10;
   dxmax100=dxmax/100;
   larmijo=1;
   if norm(g0)<1e-16,
      goon=0;
      disp('gradient is too small');
      grad=norm(g0)
   else 
      goon=1;
   end;
   while  goon
      f=feval(func ,x, 0);

     
      
      g=feval(func,x,1); normg=norm(g); normg2=normg^2;
      %use Armijo search to decide what is small: epf
      larmijo=min([larmijo,dxmax10/normg]);
      z=x-larmijo*g; fz=feval(func,z, 0); 
      steplength=norm(z-x);
      ared=f-fz;
      pred=larmijo*normg2;
      r=ared/pred;
      reduction=ared;
      if (r>0.7)&(steplength<dxmax10)
      %increase larmijo, but keep step smaller than dxmax/10.
         while (r>0.7)&(steplength<dxmax10)
            reduction=ared;
%disp('larmijo grows, ared, pred,r, k');disp([larmijo,ared,pred,r,k]);         
            larmijo=2*larmijo;
            z=x-larmijo*g; fz=feval(func,z, 0);
            
            ared=f-fz; pred=larmijo*normg2; r=ared/pred;
         end;
      else
         if r<0.3  %decrease larmijo
            while r<0.3
               larmijo=larmijo/2;
               z=x-larmijo*g; fz=feval(func,z, 0);
               ared=f-fz; pred=larmijo*normg2; r=ared/pred;
%disp('larmijo falls, ared, pred,r, k');disp([larmijo,ared,pred,r,k]);         
            end; %while
            reduction=ared;
         end; %if
      end;  %else
      %Now reduction is a large variation of f, corresponding to a 
      %Cauchy-Armijo step.
      epf=reduction/precision;
      if k==1, epx=epf/normg; end;  %small x variation, for the first iteration.
      h=[-g(2,1);g(1,1)]/normg;  %g is rotated according with direction
      if direction<0, h=-h; end;
      %predictor step: along tangent direction, until the error in f
      %value approaches epf. Do not allow a step longer than dxmax/80.
      delf=feval(func, (x+epx*h), 0)-f0;
      grande=1;
      while (abs(delf)<epf/4)&(epx<dxmax100),
         % x-precision is adjusted - epx increases
         epx=2*epx;            % so that the function variation is near ep.
         delf=feval(func, (x+epx*h), 0)-f0;
         grande=0;
      end;
      if grande==1,
         while abs(delf)>epf,  % epx decreases.
            epx=epx/2;
            delf=feval(func, (x+epx*h), 0)-fx;
         end;
      end;   
      oldx=x;
      x=x+epx*h;               %tangential step with length epx.
      fx=feval(func,x, 0);
      epf=epf/20;              %precision for corrector step
      temp=0;
      delf=fx-f0;
      while abs(delf)>epf
         g=feval(func,x,1);
         normg=norm(g); normg2=normg^2;
         if temp<6, x=x-(delf/normg2)*g;        %corrector step.
         else  x=x-(delf/(log(temp+7)*normg2))*g; %heuristic decrease of step.
         end;
         fx=feval(func,x, 0);
         delf=fx-f0;
         temp=temp+1;
      end;   
      k=k+1;
      xk(:,k)=x;
      if (norm(oldx-x0)<1.5*epx)&(k>10),   %the curve closes when x near x0
         if (g'*g0>0)&(norm(g-g0)<normg/4),        %and the gradients are near.
            goon=0; result=1; 
            xk(:,k)=x0;
         end;
      end;
      if (max(abs(x-x0))>dxmax)|(k>kmax), goon=0; result=0; end; %point far
   end
        xk=xk(:,1:k);
    iPlot = iPlot+1;
	H{iPlot} = plot(xk(1,:),xk(2,:),col,'linewidth',0.5);
   if result==1, done=1;
   else direction=-1;
   end;
end;
