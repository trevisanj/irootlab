function [Xloadings,Yloadings,Xscores,Yscores, ...
                    beta,pctVar,mse,stats] = plsregress(X,Y,ncomp,varargin)
%PLSREGRESS Partial least squares regression.
%   [XLOADINGS,YLOADINGS] = PLSREGRESS(X,Y,NCOMP) computes a partial least
%   squares regression of Y on X, using NCOMP PLS components or latent
%   factors, and returns the predictor and response loadings.  X is an N-by-P
%   matrix of predictor variables, with rows corresponding to observations,
%   columns to variables.  Y is an N-by-M response matrix.  XLOADINGS is a
%   P-by-NCOMP matrix of predictor loadings, where each row of XLOADINGS
%   contains coefficients that define a linear combination of PLS components
%   that approximate the original predictor variables.  YLOADINGS is an
%   M-by-NCOMP matrix of response loadings, where each row of YLOADINGS
%   contains coefficients that define a linear combination of PLS components
%   that approximate the original response variables.
%
%   [XLOADINGS,YLOADINGS,XSCORES] = PLSREGRESS(X,Y,NCOMP) returns the
%   predictor scores, i.e., the PLS components that are linear combinations of
%   the variables in X.  XSCORES is an N-by-NCOMP orthonormal matrix with rows
%   corresponding to observations, columns to components.
%
%   [XLOADINGS,YLOADINGS,XSCORES,YSCORES] = PLSREGRESS(X,Y,NCOMP)
%   returns the response scores, i.e., the linear combinations of the
%   responses with which the PLS components XSCORES have maximum covariance.
%   YSCORES is an N-by-NCOMP matrix with rows corresponding to observations,
%   columns to components.  YSCORES is neither orthogonal nor normalized.
%
%   PLSREGRESS uses the SIMPLS algorithm, and first centers X and Y by
%   subtracting off column means to get centered variables X0 and Y0.
%   However, it does not rescale the columns.  To perform partial least
%   squares regression with standardized variables, use ZSCORE to normalize X
%   and Y.
%
%   If NCOMP is omitted, its default value is MIN(SIZE(X,1)-1, SIZE(X,2)).
%
%   The relationships between the scores, loadings, and centered variables X0
%   and Y0 are
%
%      XLOADINGS = (XSCORES\X0)' = X0'*XSCORES,
%      YLOADINGS = (XSCORES\Y0)' = Y0'*XSCORES,
%
%   i.e., XLOADINGS and YLOADINGS are the coefficients from regressing X0 and
%   Y0 on XSCORES, and XSCORES*XLOADINGS' and XSCORES*YLOADINGS' are the PLS
%   approximations to X0 and Y0.  PLSREGRESS initially computes YSCORES as
%
%      YSCORES = Y0*YLOADINGS = Y0*Y0'*XSCORES,
%
%   however, by convention, PLSREGRESS then orthogonalizes each column of
%   YSCORES with respect to preceding columns of XSCORES, so that
%   XSCORES'*YSCORES is lower triangular.
%
%   [XL,YL,XS,YS,BETA] = PLSREGRESS(X,Y,NCOMP,...) returns the PLS regression
%   coefficients BETA.  BETA is a (P+1)-by-M matrix, containing intercept
%   terms in the first row, i.e., Y = [ONES(N,1) X]*BETA + RESIDUALS, and
%   Y0 = X0*BETA(2:END,:) + RESIDUALS.
%
%   [XL,YL,XS,YS,BETA,PCTVAR] = PLSREGRESS(X,Y,NCOMP) returns a 2-by-NCOMP
%   matrix PCTVAR containing the percentage of variance explained by the
%   model.  The first row of PCTVAR contains the percentage of variance
%   explained in X by each PLS component and the second row contains the
%   percentage of variance explained in Y.
%
%   [XL,YL,XS,YS,BETA,PCTVAR,MSE] = PLSREGRESS(X,Y,NCOMP) returns a
%   2-by-(NCOMP+1) matrix MSE containing estimated mean squared errors for
%   PLS models with 0:NCOMP components.  The first row of MSE contains mean
%   squared errors for the predictor variables in X and the second row
%   contains mean squared errors for the response variable(s) in Y.
%
%   [XL,YL,XS,YS,BETA,PCTVAR,MSE] = PLSREGRESS(...,'PARAM1',val1,...) allows
%   you to specify optional parameter name/value pairs to control the
%   calculation of MSE.  Parameters are:
%
%      'CV'      The method used to compute MSE.  When 'CV' is a positive
%                integer K, PLSREGRESS uses K-fold cross-validation.  Set
%                'CV' to a cross-validation partition, created using
%                CVPARTITION, to use other forms of cross-validation.  When
%                'CV' is 'resubstitution', PLSREGRESS uses X and Y both to
%                fit the model and to estimate the mean squared errors,
%                without cross-validation.  The default is 'resubstitution'.
%
%      'MCReps'  A positive integer indicating the number of Monte-Carlo
%                repetitions for cross-validation.  The default value is 1.
%                'MCReps' must be 1 if 'CV' is 'resubstitution'.
%      
%      'Options' A structure that specifies options that govern how PLSREGRESS
%                performs cross-validation computations. This argument can be
%                created by a call to STATSET. PLSREGRESS uses the following 
%                fields of the structure:
%                    'UseParallel'
%                    'UseSubstreams'
%                    'Streams'
%                For information on these fields see PARALLELSTATS.
%                NOTE: If supplied, 'Streams' must be of length one.
%
%   
%   [XL,YL,XS,YS,BETA,PCTVAR,MSE,STATS] = PLSREGRESS(X,Y,NCOMP,...) returns a
%   structure that contains the following fields:
%       W            P-by-NCOMP matrix of PLS weights, i.e., XSCORES = X0*W
%       T2           The T^2 statistic for each point in XSCORES
%       Xresiduals   The predictor residuals, i.e. X0 - XSCORES*XLOADINGS'
%       Yresiduals   The response residuals, i.e. Y0 - XSCORES*YLOADINGS'
%
%   Example: Fit a 10 component PLS regression and plot the cross-validation
%   estimate of MSE of prediction for models with up to 10 components.  Plot
%   the observed vs. the fitted response for the 10-component model.
%
%      load spectra
%      [xl,yl,xs,ys,beta,pctvar,mse] = plsregress(NIR,octane,10,'CV',10);
%      plot(0:10,mse(2,:),'-o');
%      octaneFitted = [ones(size(NIR,1),1) NIR]*beta;
%      plot(octane,octaneFitted,'o');
%
%   See also PRINCOMP, BIPLOT, CANONCORR, FACTORAN, CVPARTITION, STATSET,
%            PARALLELSTATS, RANDSTREAM.

% References:
%    [1] de Jong, S. (1993) "SIMPLS: an alternative approach to partial least squares
%        regression", Chemometrics and Intelligent Laboratory Systems, 18:251-263.
%    [2] Rosipal, R. and N. Kramer (2006) "Overview and Recent Advances in Partial
%        Least Squares", in Subspace, Latent Structure and Feature Selection:
%        Statistical and Optimization Perspectives Workshop (SLSFS 2005),
%        Revised Selected Papers (Lecture Notes in Computer Science 3940), C.
%        Saunders et al. (Eds.) pp. 34-51, Springer.

%   Copyright 2007-2010 The MathWorks, Inc.
%   $Revision: 1.1.8.6 $  $Date: 2010/10/08 17:26:04 $

if nargin < 2
    error(message('stats:plsregress:TooFewInputs'));
end

[n,dx] = size(X);
ny = size(Y,1);
if ny ~= n
    error(message('stats:plsregress:SizeMismatch'));
end

% Return at most maxncomp PLS components
maxncomp = min(n-1,dx);
if nargin < 3
    ncomp = maxncomp;
elseif ~isscalar(ncomp) || ~isnumeric(ncomp) || (ncomp~=round(ncomp)) || (ncomp<=0)
    error(message('stats:plsregress:BadNcomp'));
elseif ncomp > maxncomp
    error(message('stats:plsregress:MaxComponents', maxncomp));
end

names = {'cv'                  'mcreps'            'options'};
dflts = {'resubstitution'        1                      []   };
[eid,errmsg,cvp,mcreps,ParOptions] = getargs(names, dflts, varargin{:});
if ~isempty(eid)
   error(sprintf('stats:plsregress:%s',eid),errmsg);
end

if isnumeric(cvp) && isscalar(cvp) && (cvp==round(cvp)) && (0<cvp)
    % cvp is a kfold value. It will be passed as such to crossval.
    if (cvp>n)
        error('stats:plsregress:InvalidCV', ...
              'CV must be less than or equal to the number of rows in X.');
    end
    % cvp is a kfold value. It will be passed as such to crossval.
elseif isequal(cvp,'resubstitution')
    % ok
elseif isa(cvp,'cvpartition')
    if strcmp(cvp.Type,'resubstitution')
        cvp = 'resubstitution';
    else
        % ok
    end
else
    error('stats:plsregress:InvalidCV', ...
          'CV must be a positive integer or a partition created with CVPARTITION.');
end

if ~(isnumeric(mcreps) && isscalar(mcreps) && (mcreps==round(mcreps)) && (0<mcreps))
    error('stats:plsregress:InvalidMCReps', 'MCReps must be a positive integer.');
elseif mcreps > 1 && isequal(cvp,'resubstitution')
    error('stats:plsregress:InvalidMCReps', 'MCReps must be 1 for resubstitution.');
end

% Center both predictors and response, and do PLS
meanX = mean(X,1);
meanY = mean(Y,1);
X0 = bsxfun(@minus, X, meanX);
Y0 = bsxfun(@minus, Y, meanY);

if nargout <= 2
    [Xloadings,Yloadings] = simpls(X0,Y0,ncomp);
    
elseif nargout <= 4
    [Xloadings,Yloadings,Xscores,Yscores] = simpls(X0,Y0,ncomp);
    
else
    % Compute the regression coefs, including intercept(s)
    [Xloadings,Yloadings,Xscores,Yscores,Weights] = simpls(X0,Y0,ncomp);
    beta = Weights*Yloadings';
    beta = [meanY - meanX*beta; beta];
    
    % Compute the percent of variance explained for X and Y
    if nargout > 5
        pctVar = [sum(abs(Xloadings).^2,1) ./ sum(sum(abs(X0).^2,1));
                  sum(abs(Yloadings).^2,1) ./ sum(sum(abs(Y0).^2,1))];
    end
    
    if nargout > 6
        if isequal(cvp,'resubstitution')
            % Compute MSE for models with 0:ncomp PLS components, by
            % resubstitution.  CROSSVAL can handle this, but don't waste time
            % fitting the whole model again.
            mse = zeros(2,ncomp+1,class(pctVar));
            mse(1,1) = sum(sum(abs(X0).^2, 2));
            mse(2,1) = sum(sum(abs(Y0).^2, 2));
            for i = 1:ncomp
                X0reconstructed = Xscores(:,1:i) * Xloadings(:,1:i)';
                Y0reconstructed = Xscores(:,1:i) * Yloadings(:,1:i)';
                mse(1,i+1) = sum(sum(abs(X0 - X0reconstructed).^2, 2));
                mse(2,i+1) = sum(sum(abs(Y0 - Y0reconstructed).^2, 2));
            end
            mse = mse / n;
            % We now have the reconstructed values for the full model to use in
            % the residual calculation below
        else
            % Compute MSE for models with 0:ncomp PLS components, by cross-validation
            mse = plscv(X,Y,ncomp,cvp,mcreps,ParOptions);
            if nargout > 7
                % Need these for the residual calculation below
                X0reconstructed = Xscores*Xloadings';
                Y0reconstructed = Xscores*Yloadings';
            end
        end
    end
    
    if nargout > 7
        % Save the PLS weights and compute the T^2 values.
        stats.W = Weights;
        stats.T2 = sum( bsxfun(@rdivide, abs(Xscores).^2, var(Xscores,[],1)) , 2);
        
        % Compute X and Y residuals
        stats.Xresiduals = X0 - X0reconstructed;
        stats.Yresiduals = Y0 - Y0reconstructed;
    end
end


%------------------------------------------------------------------------------
%SIMPLS Basic SIMPLS.  Performs no error checking.
function [Xloadings,Yloadings,Xscores,Yscores,Weights] = simpls(X0,Y0,ncomp)

[n,dx] = size(X0);
dy = size(Y0,2);

% Preallocate outputs
outClass = superiorfloat(X0,Y0);
Xloadings = zeros(dx,ncomp,outClass);
Yloadings = zeros(dy,ncomp,outClass);
if nargout > 2
    Xscores = zeros(n,ncomp,outClass);
    Yscores = zeros(n,ncomp,outClass);
    if nargout > 4
        Weights = zeros(dx,ncomp,outClass);
    end
end

% An orthonormal basis for the span of the X loadings, to make the successive
% deflation X0'*Y0 simple - each new basis vector can be removed from Cov
% separately.
V = zeros(dx,ncomp);

Cov = X0'*Y0;
for i = 1:ncomp
    % Find unit length ti=X0*ri and ui=Y0*ci whose covariance, ri'*X0'*Y0*ci, is
    % jointly maximized, subject to ti'*tj=0 for j=1:(i-1).
    [ri,si,ci] = svd(Cov,'econ'); ri = ri(:,1); ci = ci(:,1); si = si(1);
    ti = X0*ri;
    normti = norm(ti); ti = ti ./ normti; % ti'*ti == 1
    Xloadings(:,i) = X0'*ti;
    
    qi = si*ci/normti; % = Y0'*ti
    Yloadings(:,i) = qi;
    
    if nargout > 2
        Xscores(:,i) = ti;
        Yscores(:,i) = Y0*qi; % = Y0*(Y0'*ti), and proportional to Y0*ci
        if nargout > 4
            Weights(:,i) = ri ./ normti; % rescaled to make ri'*X0'*X0*ri == ti'*ti == 1
        end
    end

    % Update the orthonormal basis with modified Gram Schmidt (more stable),
    % repeated twice (ditto).
    vi = Xloadings(:,i);
    for repeat = 1:2
        for j = 1:i-1
            vj = V(:,j);
            vi = vi - (vj'*vi)*vj;
        end
    end
    vi = vi ./ norm(vi);
    V(:,i) = vi;

    % Deflate Cov, i.e. project onto the ortho-complement of the X loadings.
    % First remove projections along the current basis vector, then remove any
    % component along previous basis vectors that's crept in as noise from
    % previous deflations.
    Cov = Cov - vi*(vi'*Cov);
    Vi = V(:,1:i);
    Cov = Cov - Vi*(Vi'*Cov);
end

if nargout > 2
    % By convention, orthogonalize the Y scores w.r.t. the preceding Xscores,
    % i.e. XSCORES'*YSCORES will be lower triangular.  This gives, in effect, only
    % the "new" contribution to the Y scores for each PLS component.  It is also
    % consistent with the PLS-1/PLS-2 algorithms, where the Y scores are computed
    % as linear combinations of a successively-deflated Y0.  Use modified
    % Gram-Schmidt, repeated twice.
    for i = 1:ncomp
        ui = Yscores(:,i);
        for repeat = 1:2
            for j = 1:i-1
                tj = Xscores(:,j);
                ui = ui - (tj'*ui)*tj;
            end
        end
        Yscores(:,i) = ui;
    end
end


%------------------------------------------------------------------------------
%PLSCV Efficient cross-validation for X and Y mean squared error in PLS.
function mse = plscv(X,Y,ncomp,cvp,mcreps,ParOptions)

[n,dx] = size(X);

% Return error for as many components as asked for; some columns may be NaN
% if ncomp is too large for CV.
mse = NaN(2,ncomp+1);

% The CV training sets are smaller than the full data; may not be able to fit as
% many PLS components.  Do the best we can.
if isa(cvp,'cvpartition')
    cvpType = 'partition';
    maxncomp = min(min(cvp.TrainSize)-1,dx);
else
    cvpType = 'Kfold';
%    maxncomp = min(min( floor((n*(cvp-1)/cvp)-1), dx));
    maxncomp = min( floor((n*(cvp-1)/cvp)-1), dx);
end
if ncomp > maxncomp
    warning(message('stats:plsregress:MaxComponentsCV', maxncomp));
    ncomp = maxncomp;
end

% Cross-validate sum of squared errors for models with 1:ncomp components,
% simultaneously.  Sum the SSEs over CV sets, and compute the mean squared
% error
CVfun = @(Xtr,Ytr,Xtst,Ytst) sseCV(Xtr,Ytr,Xtst,Ytst,ncomp);
sumsqerr = crossval(CVfun,X,Y,cvpType,cvp,'mcreps',mcreps,'options',ParOptions);
mse(:,1:ncomp+1) = reshape(sum(sumsqerr,1)/(n*mcreps), [2,ncomp+1]);


%------------------------------------------------------------------------------
%SSECV Sum of squared errors for cross-validation
function sumsqerr = sseCV(Xtrain,Ytrain,Xtest,Ytest,ncomp)

XmeanTrain = mean(Xtrain);
YmeanTrain = mean(Ytrain);
X0train = bsxfun(@minus, Xtrain, XmeanTrain);
Y0train = bsxfun(@minus, Ytrain, YmeanTrain);

% Get and center the test data
X0test = bsxfun(@minus, Xtest, XmeanTrain);
Y0test = bsxfun(@minus, Ytest, YmeanTrain);

% Fit the full model, models with 1:(ncomp-1) components are nested within
[Xloadings,Yloadings,~,~,Weights] = simpls(X0train,Y0train,ncomp);
XscoresTest = X0test * Weights;

% Return error for as many components as the asked for.
outClass = superiorfloat(Xtrain,Ytrain);
sumsqerr = zeros(2,ncomp+1,outClass); % this will get reshaped to a row by CROSSVAL

% Sum of squared errors for the null model
sumsqerr(1,1) = sum(sum(abs(X0test).^2, 2));
sumsqerr(2,1) = sum(sum(abs(Y0test).^2, 2));

% Compute sum of squared errors for models with 1:ncomp components
for i = 1:ncomp
    X0reconstructed = XscoresTest(:,1:i) * Xloadings(:,1:i)';
    sumsqerr(1,i+1) = sum(sum(abs(X0test - X0reconstructed).^2, 2));

    Y0reconstructed = XscoresTest(:,1:i) * Yloadings(:,1:i)';
    sumsqerr(2,i+1) = sum(sum(abs(Y0test - Y0reconstructed).^2, 2));
end

