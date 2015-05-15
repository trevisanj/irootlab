%> @brief Sparse LDA
%>
%> <h3>References</h3>
%> Hastie et al, Elements of Statistical Learning, 2nd ed. Springer.
%>
%> @sa fisher_ld.m, uip_fcon_lda.m
classdef fcon_slda < fcon_linear
    properties
        max_loadings;
    end;
    
    methods
        function o = fcon_slda()
            o.classtitle = 'Sparse LDA';
            o.short = 'SLDA';
            o.flag_trainable = 1;
            o.L_fea_prefix = 'SLDA';
            o.flag_params = 0;
        end;

    end;
    
    methods(Access=protected)
        function o = do_train(o, data)
            
%   delta = 1e-3; % l2-norm constraint
%   stop = -30; % request 30 non-zero variables
%   maxiter = 250; % maximum number of iterations
%   Q = 2; % request two discriminative directions
%   convergenceCriterion = 1e-6;
% 
%   % normalize training and test data
%   [X mu d] = normalize(X);
%   X_test = (X_test-ones(n,1)*mu)./sqrt(ones(n,1)*d);
% 
%   % run SLDA
%   [B theta] = slda(X, Y, delta, stop, Q, maxiter, convergenceCriterion, true);

            
            o.L = slda(data.X, classes2boolean(data.classes), 1e-3, -20, 4, 500, 1e-24, true);
            
            if ~isempty(o.max_loadings)
                o.L = o.L(:, min(size(o.L, 2), o.max_loadings));
            end;
            
            o.L_fea_x = data.fea_x;
            o.xname = data.xname;
            o.xunit = data.xunit;
        end;
    end;
end