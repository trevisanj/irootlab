%> @brief Linear and Quadratic discriminant
%>
%> Fits a Gaussian to each class. In the linear case, sa polled co-variance matrix is calculated. In the quadratic case, each class has its
%> own co-variance matrix
%>
%> The problem with MATLAB's classify() is that it is not possible to call the training and use separately.
%>
%> @sa uip_clssr_d.m
classdef clssr_d < clssr
    properties
        %> ='linear'. Possibilities: 'linear' or 'quadratic'.
        type = 'linear';
        %> =1. Whether or not to use priors. Setting to ZERO is a way to account for unbalanced classes.
        flag_use_priors = 1;
    end;
    
    properties(SetAccess=protected)
        % Inverse of polled covariance matrix (linear case)
        invcov;
        % Determinant of polled covariance matrix (linear case)
        detcov;
        % Inverse of covariance matrices per class (quadratic case) (cell of matrices).
        invcovs;
        % Determinant of polled covariance matrices (quadratic case) (vector of scalars).
        detcovs;
        % [nc]x[nf] matrix. Class means
        means = {};
        % Probability of belonging to each class - calculated from training data
        priors;
        R = {};
        logDetSigma;
    end;
        
    
    properties(Access=private)
        X;
        classes;
    end;

    methods
        function o = clssr_d(o)
            o.classtitle = 'Gaussian fit';
        end;

% Better not implement these things        %> If title is not empty, will not mess with description too much
%        function s = get_description(o)
%            if ~isempty(o.title)
%                s = get_description@clssr(o);
%            else
%                s = [get_description@clssr(o), ' type = ', o.type];
%            end;
%        end;
    end;
    
    methods(Access=protected)
        
        
        %> Bits extracted fro MATLAB's classify()
        %>
        function o = do_train(o, data)
            o.classlabels = data.classlabels;

            t = tic();
            
            o.means = zeros(data.nc, data.nf);
            for k = data.nc:-1:1 % Backwards for allocation
                Xtemp = data.X(data.classes == k-1, :);
                nonow = size(Xtemp, 1);
                
                o.means(k, :) = mean(Xtemp);
                if o.flag_use_priors
                    o.priors(k) = nonow;
                else
                    o.priors(k) = 1;
                end;
            end;
            o.priors = o.priors/sum(o.priors);

            switch o.type
                case 'linear'
                    % Pooled estimate of covariance.  Do not do pivoting, so that A can be
                    % computed without unpermuting.  Instead use SVD to find rank of R.
                    [Q,R] = qr(data.X - o.means(data.classes+1, :), 0); %#ok<*PROP>
                    o.R = R / sqrt(data.no-data.nc); % SigmaHat = R'*R
                    s = svd(R);
                    if any(s <= max(data.no, data.nf) * eps(max(s)))
                        irerror(sprintf('The pooled covariance matrix of TRAINING must be positive definite. There are probably too few spectra (%d) or too many variables (%d)!', data.no, data.nf));
                    end
                    o.logDetSigma = 2*sum(log(s)); % avoid over/underflow
                
                case 'quadratic'
                    
                    o.R = cell(1, data.nc);
                    
                    o.logDetSigma = zeros(data.nc, 1);
                    for k = 1:data.nc
                        Xtemp = data.X(data.classes == k-1, :);
                        nonow = size(Xtemp, 1);
                %                         o.means{k} = mean(Xtemp);
                        
                        % Stratified estimate of covariance.  Do not do pivoting, so that A
                        % can be computed without unpermuting.  Instead use SVD to find rank
                        % of R.
                        [Q,Rk] = qr(bsxfun(@minus, Xtemp, o.means(k, :)), 0);
                        o.R{k} = Rk / sqrt(nonow - 1); % SigmaHat = R'*R
                        s = svd(o.R{k});
                        if any(s <= max(nonow,data.nf) * eps(max(s)))
                            irerror(sprintf(['The covariance of each class in TRAINING must ',...
                                'be positive definite. There are probably too few spectra in ', ...
                                'class "%s" (%d) or too many variables (%d)!'], ...
                                data.classlabels{k}, size(Xtemp, 1), data.nf));
%                             irerror('The covariance matrix of each group in TRAINING must be positive definite. There are probably too few spectra or too many variables!');
                        end
                        o.logDetSigma(k) = 2*sum(log(s)); % avoid over/underflow
            
                    end;
                    
                otherwise
                    irerror(sprintf('Unknown type: %s', o.type));
            end;

            o.time_train = toc(t);
        end;
        
        
        %> With bits from MATLAB classify()
        function est = do_use(o, data)
            est = estimato();
            est.classlabels = o.classlabels;
            est = est.copy_from_data(data);

            t = tic();
            
            nc = numel(o.classlabels);
            
            posteriors = zeros(data.no, nc);
            
            switch o.type
                case 'linear'
                    % MVN relative log posterior density, by group, for each sample
                    for k = 1:nc
                        A = bsxfun(@minus, data.X, o.means(k,:)) / o.R;
                        posteriors(:,k) = o.priors(k)*exp(-.5*(sum(A.*A, 2)+o.logDetSigma));
                    end
                    
                case 'quadratic'
                    for k = 1:nc
                        A = bsxfun(@minus, data.X, o.means(k, :))/o.R{k};
                        
                        % MVN relative log posterior density, by group, for each sample
%                         D(:,k) = log(prior(k)) - .5*(sum(A .* A, 2) + logDetSigma(k));
                        posteriors(:,k) = o.priors(k)*exp(-.5*(sum(A.*A, 2)+o.logDetSigma(k)));
%                         posteriors(:,k) = log(o.priors(k))-.5*(sum(A.*A, 2)+o.logDetSigma(k));
                    end;
            end
            
            posteriors = normalize_rows(posteriors);
                    
            est.X = posteriors;
            o.time_use = toc(t);
        end;
        
    end;
end