function powerfd = power(fdobj, a, tol)
%  A positive integer pointwise power of a functional data object with 
%  a B-splinebasis.  powerfd = fdobj.^a
%  The basis is tested for being a B-spline basis.  The function then
%  sets up a new spline basis with the same knots but with an order
%  that is M-1 higher than the basis for FDOBJ, where M = ceil(a),
%  so that the order of differentiability for the new basis is 
%  appropriate in the event that a is a positive integer, and also
%  to accommodate the addition curvature arising from taking a power.
%  The power of the values of the function over a fine mesh are computed,
%  and these are fit using the new basis.
%
%  Powers should be requested with caution, however, and especially if
%  a < 1, because, if there is strong local curvature in FDOBJ, 
%  and if its basis is just barely adequate to capture this curvature, 
%  then the power of the function may have considerable error 
%  over this local area.  fdobj.^a where a is close to zero is just
%  such a situation.
%
%  If a power of a functional data object is required for which the
%  basis is not a spline, it is better to either re-represent the
%  function in a spline basis, or, perhaps even better, to do the 
%  math required to get the right basis and interpolate function
%  values over a suitable mesh.  This is especially true for fourier
%  bases.

%  Last modified 26 February 2009

if nargin < 2,  error('Number of arguments is less than two.');  end
if nargin < 3,  tol = 1e-4;  end

%  Test a for being a positive integer

if a < 0
    error('Exponent is not positive.');
end

basisobj = getbasis(fdobj);

%  test the basis for being of B-spline type

if ~strcmp('bspline',getbasistype(basisobj))
    error('FDOBJ does not have a spline basis.');
end

nbasis        = getnbasis(basisobj);
rangeval      = getbasisrange(basisobj);
interiorknots = getbasispar(basisobj);
norder        = nbasis - length(interiorknots);

coefmat = getcoef(fdobj);
coefd   = size(coefmat);
    ncurve = coefd(2);
if length(coefd) == 2
    nvar = 1;
else
    nvar = coefd(3);
end

%  a == 0:  set up a constant basis and return the unit function(s)

if a == 0
    newbasis = create_constant_basis(rangeval);
    if nvar == 1
      powerfd = fd(ones(1,ncurve), newbasis);
    else
      powerfd = fd(ones(1,ncurve,nvar), newbasis);
    end
    return;
end

%  a == 1:  return the function

if a == 1
    powerfd = fdobj;
    return;
end

%  Otherwise:

m = ceil(a);

if m == a && m > 1
    
    %  a is an integer greater than one
    
    newnorder = norder*(m-1);
    if length(interiorknots) < 9
        newbreaks = linspace(rangeval(1), rangeval(2), 11);
    else
        newbreaks = [rangeval(1), interiorknots, rangeval(2)];
    end
    nbreaks   = length(newbreaks);
    newnbasis = newnorder + nbreaks - 2;
    newbasis  = create_bspline_basis(rangeval, newnbasis, newnorder, ...
                                     newbreaks);
    nmesh   = max([10*nbasis+1,101]);
    tval    = linspace(rangeval(1),rangeval(2),nmesh);
    fmat    = eval_fd(tval, fdobj);
    ymat    = fmat.^a;
    ytol    = max(abs(ymat(:))).*tol;
    powerfd = smooth_basis(tval, ymat, newbasis);
    ymathat = eval_fd(tval,powerfd);
    ymatres = ymat - ymathat;
    maxerr  = max(abs(ymatres(:)));
    disp([maxerr,ytol])
    while  maxerr > ytol && nbreaks < nmesh
        newnbasis = newnorder + nbreaks - 2;
        newbasis  = create_bspline_basis(rangeval, newnbasis, newnorder, newbreaks);
        newfdPar  = fdPar(newbasis, 2, 1e-20);
        powerfd   = smooth_basis(tval, ymat, newfdPar);
        ymathat   = eval_fd(tval,powerfd);
        ymatres   = ymat - ymathat;
        maxerr    = max(abs(ymatres(:)));
        disp([maxerr,ytol])
        if nbreaks*2 <= nmesh
        newbreaks = sort([newbreaks, ...
            (newbreaks(1:(nbreaks-1))+newbreaks(2:nbreaks))./2]);
        else
            newbreaks = tval;
        end
        nbreaks = length(newbreaks);
    end
    
    disp([nmesh, nbreaks])
    
    if maxerr > ytol
        warning('The maximum error exceeds the tolerance level.');
    end
    
    return

else
    
    %  a is fractional or negative
    
    if any(coefmat(:) <= 0)
        error('There is a potential for negative or zero values.');
    end

    if length(interiorknots) < 9
        newbreaks = linspace(rangeval(1), rangeval(2), 11);
    else
        newbreaks = [rangeval(1), interiorknots, rangeval(2)];
    end
    nbreaks   = length(newbreaks);
    newnorder = max([4, norder+m-1]);
    newnbasis = newnorder + nbreaks - 2;
    newbasis  = create_bspline_basis(rangeval, newnbasis, newnorder, ...
                                     newbreaks);
    nmesh     = max([10*nbasis+1,101]);
    tval      = linspace(rangeval(1),rangeval(2),nmesh);
    fmat      = eval_fd(tval, fdobj);
    ymat      = fmat.^a;
    ytol      = max(abs(ymat(:))).*tol;
    newfdPar  = fdPar(newbasis, 2, 1e-20);
    powerfd   = smooth_basis(tval, ymat, newfdPar);
    ymathat   = eval_fd(tval,powerfd);
    ymatres   = ymat - ymathat;
    maxerr    = max(abs(ymatres(:)));
    disp([maxerr, ytol])
    while maxerr > ytol && nbreaks < nmesh
        newnbasis = newnorder + nbreaks - 2;
        newbasis  = create_bspline_basis(rangeval, newnbasis, newnorder, newbreaks);
        newfdPar  = fdPar(newbasis, 2, 1e-20);
        powerfd   = smooth_basis(tval, ymat, newfdPar);
        ymathat   = eval_fd(tval,powerfd);
        ymatres   = ymat - ymathat;
        maxerr    = max(abs(ymatres)).*tol;
        disp([maxerr, ytol])
        if nbreaks*2 <= nmesh
        newbreaks = sort([newbreaks, ...
            (newbreaks(1:(nbreaks-1))+newbreaks(2:nbreaks))./2]);
        else
            newbreaks = tval;
        end
        nbreaks = length(newbreaks);
    end
    
    if maxerr > ytol
        warning('The maximum error exceeds the tolerance level.');
    end

    return

end

