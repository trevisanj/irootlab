% function fdobj = setcoef(fdobj, coef)
% last modified Monday 27 July 2009
function fdobj = setcoef(fdobj, coef)

  if isa_fd(fdobj) || isa_basis(fdobj)
      fdobj.coef = coef;
  else
    error(['Argument is neither a functional data object', ...
           ' nor a functional basis object.']);
  end

