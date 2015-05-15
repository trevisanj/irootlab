function subfd = subsref(fdobj, substr)
%  SUBSREF  subscripted reference to a functional data object
%    FDOBJ  ... an object of class 'fd'
%    SUBSTR ... a cell object containing the subscripts

%  last modified 4 March 2009

coef = getcoef(fdobj);

type = substr.type;

if strcmp(type, '.')
    subfd = eval(['fdobj',substr.subs{2}]);
elseif strcmp(type, '()')
    sizec = size(coef);
    ndim  = length(sizec);
    subs  = substr.subs;
    nsubs = length(subs);
    switch nsubs
        case 1
            switch ndim
                case 2
                    newcoef = coef(:,subs{1});
                case 3
                    newcoef = coef(:,subs{1},:);
                otherwise
                    error('Wrong no. dimensions for COEF.');
            end
        case 2
            switch ndim
                case 2
                    error('Too many subscripts.');
                case 3
                    newcoef = coef(:,subs{1},subs{2});
                otherwise
                    error('Wrong no. dimensions for COEF.');
            end
        case 3
            error('Too many subscripts.');
    end
    
    nrep = sizec(2);
    if ndim == 2
        nvar = 1;
    else
        nvar = sizec(3);
    end

    subfd.coef     = newcoef;
    subfd.basisobj = getbasis(fdobj);
    fdnames        = getnames(fdobj);
    caselabels     = getfdlabels(fdnames{2},nrep);
    varlabels      = getfdlabels(fdnames{3},nvar);
    if ~isempty(caselabels)
        fdnames{2}{2} = caselabels(subs{1},:);
    end
    if ~isempty(varlabels)
        fdnames{3}{2} = varlabels(subs{2},:);
    end
    subfd.fdnames = fdnames;

    subfd = class(subfd, 'fd');
else
    error('Cell subscripting is not allowed, refer by field name.');
end

