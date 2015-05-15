function fdlabels = getfdlabels(fdname, nlabel)
%  Extract labels from one of the label cells for 
%  a functional data object.
%  Arguments:
%  FDNAMES ... One of fdnames{1}, fdnames{2} or fdnames{3}
%  NLABEL  ... Number of rows of the character matrix in
%              FDNAME{2} if it has been supplied.
%  If FDNAME is not a cell array of length 2, or the
%  character array is not of the appropriate size, 
%  the returned label array is empty.

%  Last modified 3 March 2009

if ~isempty(fdname) && iscell(fdname)
    if length(fdname) == 2 && ...
       ischar(fdname{2})   && ...
       size(fdname{2},1) == nlabel
        fdlabels = fdname{2};
    else
        fdlabels = [];
    end
else
    fdlabels = [];
end

