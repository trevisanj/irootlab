%> @brief Lasso Classifier
%>
%> This is a 2-class classifier, won't work if dataset has more than two classes.
%>
%> This classifier cannot correct for weights either, so if the dataset is unbalanced, it is better to undersample the dataset to balance the classes
%>
%> This classifier uses a LASSO function that has no "intercept" in it, it assumes that the variables have been mean-centered, so the variables need to be
%> mean-centered. Standardization is actually recommended!
%>
%> In order to use with more than two classes, please encapsulate inside an aggr_pairs
classdef clssr_lasso < clssr
    properties
        %> Number of features to have non-zero coefficient
        nf_select = 1;
        
        flag_precond = 0;
        precond_threshold = 0;
        precond_no_factors = 10;
    end;
    
    properties(SetAccess=protected)
        %> Regression coefficients
        L;
    end;

    methods
        function o = clssr_lasso()
            o.classtitle = 'LASSO';
            o.flag_ui = 0;
        end;
    end;
    
    methods(Access=protected)
        
        function o = do_boot(o)
        end;
        
        

        % TODO actually this could even be multiple-trainable
        function o = do_train(o, data)
            o.classlabels = data.classlabels;
           
            tic;

%                 ww = data.get_weights(); % weights per class
%                 weights = zeros(1, data.no); % weights per observation
% 
%                 for i = 1:data.nc
%                     weights(data.classes == i-1) = ww(i);
%                 end;
%                 
                
            if data.nc ~= 2
                irerror('Lasso classifier works with two classes only!');
            end;
            
            % assert_meancentered(data.X, 1e-4);
            
            Y = data.classes*2-1;
            if ~o.flag_precond
                
            else
%                 if 0
                    % Univariate regression
                    a = zeros(data.nf, 1);
                    for i = 1:data.nf
                        X = data.X(:, i);
                        a(i) = X'*Y/(X'*X);
                    end;

                    % Excludes features corresponding to small threshold
                    ii = 1:data.nf;
                    ii(a < o.precond_threshold) = [];
                    X = data.X(:, ii);

                    % PCA of reduced matrix
                    [L, S] = princomp2(X); %#ok<PROP>
                    S = S(:, 1:min(o.precond_no_factors, size(S, 2)));
% 
%                 else
%                     S = data.X;
%                 end;
                
                % Least-squares regression to finally compute the Y for the Lasso
                Y = S*((S'*S)\(S'*Y));
            end;
                
                


            o.L = lasso(data.X, Y, -o.nf_select, false);

    
            o.time_train = toc;
        end;
        
        
        
        function est = do_use(o, data)
            est = estimato();
            est.classlabels = o.classlabels;
            est = est.copy_from_data(data);

            tic();
            
            Y = data.X*o.L; % regression in action
            Y(Y < -1) = -1; % Contains estimations between -1 ...
            Y(Y > 1) = 1; % ... and 1
            Y = Y/2+0.5;  % normalizes to 0-1 instead
            
            Y = [1-Y, Y]; % makes matrix of posterior probabilities for a 2-class classifier
            
            est.X = Y;
                        
            o.time_use = toc();
        end;
    end;
end