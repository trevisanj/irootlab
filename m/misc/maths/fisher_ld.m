%>@ingroup maths
%>@file
%>@brief Calculates Fisher's Linear Discriminant vectors (loadings).
%>
%> If either data or pieces is passed, the scatter matrixes will be
%> calculated.
%>
%> The rank of @c S_W (within-class scatter matrix) will be tested, and if it is lower
%> than the dimensionality of the problem (i.e., number of features), PCA
%> will be run first to project the data onto a space where the within-class 
%> scatter matrix (say @c S_W_PCA) will be non-singular and then the obtained
%> LDA loadings will be projected back to the original space.
%>
%> The equation to solve [1]:
%>
%> @code
%> S_B*w = lambda*S_W*w 
%> @endcode
%>
%> There are rank(S_B) (at most no_classes-1) different w's.
%>
%> <h3>References:</h3>
%> ﻿[1] R. O. Duda, P. E. Hart, and D. G. Stork, Pattern Classification, 2nd ed. New York: John Wiley & Sons, 2001.
%>
%> ﻿[2] T. Hastie, J. H. Friedman, and R. Tibshirani, The Elements of Statistical Learning, 2nd ed. New York: Springer, 2007.
%>
%> @sa calculate_scatters.m
%>
%> @param data Dataset
%> @param flag_sphere=0. Deac
%> @param flag_modified_s_b: see calculate_scatters.m
%> @param n_max Maximum number of loadings vectors to be returned
%> @return <em>[W_star]</em> or <em>[W_star, lambdas]</em>

function [W_star, varargout] = fisher_ld(data, flag_sphere, flag_modified_s_b, P, n_max)

flag_sphere = 0;

if data.nc < 2
    irerror('Cannot run LDA on dataset with less than 2 classes!');
end;

if ~exist('flag_modified_s_b', 'var')
    flag_modified_s_b = 0;
end;

s = 'None';

if ~exist('P')
    P = 0;
end;
flag_p = any(P(:) ~= 0);

flag_n_max = nargin >= 5 && ~isempty(n_max);


[S_B, S_W] = data_calculate_scatters(data, flag_modified_s_b, P);

[V, D] = eig(S_B, S_W);

no_lambdas = size(D, 2);

% Creates an index table and sorts it by eigenvalue in ascending order
% (because sortrows() hasn't a descending order option)
lambdas = diag(D);
[vv, ii] = sort(lambdas, 'descend');

% % % if numel(vv) < data.nc-1
% % % %     disp('OLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLHAAAAA');
% % % %     dbstack;
% % % %     keyboard;
% % % end;

if ~flag_p
    % Returns the nc-1 vectors corresponding to the c-1 largest eigenvalues
    if flag_n_max
        % eigenvectors in descending order of eigenvalue
        W_star = V(:, ii(1:min([data.nc-1, n_max, data.nf])));
    else
        W_star = V(:, ii(1:min([data.nc-1, data.nf])));
    end;
else
    if flag_n_max
        W_star = V(:, ii(1:min(size(V, 2), n_max)));
    else
        
        W_star = V(:, ii);
    end;
end;

% % % % % % % % % % % % % % % % % % % % % %> keyboard;
% % % % % % % % % % % % % % % % % % % % % lambdas(:, 2) = (1:no_lambdas)';
% % % % % % % % % % % % % % % % % % % % % lambdas = sortrows(lambdas);
% % % % % % % % % % % % % % % % % % % % % 
% % % % % % % % % % % % % % % % % % % % % % sweeps the [lambda, index] table backwards in search for no_classes-1
% % % % % % % % % % % % % % % % % % % % % % largest and properly numeric eigenvalues
% % % % % % % % % % % % % % % % % % % % % W_star = zeros(data.nf, data.nc-1);
% % % % % % % % % % % % % % % % % % % % % lambdas2 = zeros(no_lambdas, 1);
% % % % % % % % % % % % % % % % % % % % % maxlambda = max(lambdas(:, 1));
% % % % % % % % % % % % % % % % % % % % % no_found = 0;
% % % % % % % % % % % % % % % % % % % % % for i = no_lambdas:-1:1
% % % % % % % % % % % % % % % % % % % % %     lambda = lambdas(i, 1);
% % % % % % % % % % % % % % % % % % % % % %     if lambda ~= NaN & lambda ~= Inf & lambda > maxlambda*1e-6
% % % % % % % % % % % % % % % % % % % % %         no_found = no_found+1;
% % % % % % % % % % % % % % % % % % % % %         
% % % % % % % % % % % % % % % % % % % % %         v_temp = V(:, lambdas(i, 2));
% % % % % % % % % % % % % % % % % % % % %         W_star(:, no_found) = v_temp/norm(v_temp);
% % % % % % % % % % % % % % % % % % % % %         lambdas2(no_found) = lambdas(i, 1);
% % % % % % % % % % % % % % % % % % % % %         
% % % % % % % % % % % % % % % % % % % % %         if no_found >= 3 %data.nc-1
% % % % % % % % % % % % % % % % % % % % %             break;
% % % % % % % % % % % % % % % % % % % % %         end;
% % % % % % % % % % % % % % % % % % % % % %     end;
% % % % % % % % % % % % % % % % % % % % % end;
% % % % % % % % % % % % % % % % % % % % % 
% % % % % % % % % % % % % % % % % % % % % 
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % Don't mess here again, JULIO, this needs to be like that, unnormalized
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % W_star = adjust_unitnorm(W_star);
% % % % % % % % % % % % % % % % % % % % % % W_star = adjust_turn(W_star);
% % % % % % % % % % % % % % % % % % % % % 
% % % % % % % % % % % % % % % % % % % % % if no_found < (data.nc-1)
% % % % % % % % % % % % % % % % % % % % %     W_star = W_star(:, 1:no_found);
% % % % % % % % % % % % % % % % % % % % % end


if nargout() == 2
  varargout(1) = {vv}; 
end;

% irverbose('F-LDA applied');

















































% flag_sphere = 0;
% 
% if data.nc < 2
%     irerror('Cannot run LDA on dataset with less than 2 classes!');
% end;
% 
% if ~exist('flag_modified_s_b', 'var')
%     flag_modified_s_b = 0;
% end;
% 
% s = 'None';
% 
% if ~exist('P')
%     P = 0;
% end;
% 
% flag_pca = 0;
% 
% [S_B, S_W] = data_calculate_scatters(data, flag_modified_s_b, P);
% % S_W = diag(diag(S_W));
% 
% % S_W = eye(size(S_W, 1)); %>  HACK let's try to see how it is dealt with if S_W is an eye
% 
% rsw = rank(S_W);
% flag_deficient = rank(S_W) < length(S_W);
% 
% if flag_sphere && flag_deficient
%   error('Cannot make S_W spherical because it is singular!');
% end;
% 
% if flag_sphere
%     [V, lambdas] = eig_ordered(S_W);
%   
%     V_ = V/sqrt(diag(lambdas));
%     X = X*V_;
% 
%     [S_B, S_W] = data_calculate_scatters(data, flag_modified_s_b, P);
% end;
% 
% if flag_deficient
%     fprintf('Fisher''s LDA will be calculated in PC eigenspace because rank(S_W) = %>d which is lower than %>d\n', rsw, length(S_W));
%     flag_pca = 1;
% 
%     [loadings_pca, scores] = princomp2(data.X);
%     no_factors = size(scores, 2);
%     
%     if rsw < no_factors
%         fprintf('PCA Scores matrix will be truncated from %>d to %>d columns to match rank of S_W.\n', no_factors, rsw);
%         scores = scores(:, 1:rsw);
%         loadings_pca = loadings_pca(:, 1:rsw);
%     elseif no_factors < rsw
%         fprintf('Actually, the number of PCA factors derived (%>d) was even lower than %>d said before.\n', no_factors, rsw);
%         rsw = no_factors;
%     end;
% 
%     data.X = scores;
% 
%     [S_B, S_W] = data_calculate_scatters(data, flag_modified_s_b, P);
% end;
% 
% no_classes = rank(S_B)+1;
% nf = size(S_B, 1);
% 
% rank_S_W = rank(S_W);
% %> if rank_S_W < nf
% %>     error('Cannot calculate Fisher Linear Discriminant because rank(S_W) = %>d which is lower than %>d.\n', rank_S_W, nf);
% %> end;
% 
% %> if flag_sphere
% %> %>     [V, D] = eigs(S_B, no_classes-1);
% %>      [V, D] = eig(S_B);
% %>      V = V(:, 1:(no_classes-1));
% %>      D = D(:, 1:(no_classes-1));
% %> else
% %>     OPTS.tol = 1e-50;
% [V, D] = eigs(S_B, S_W, no_classes-1);
% % end;
% % [V, D] = eig(S_B, S_W);
% 
% no_lambdas = size(D, 2);
% 
% % Creates an index table and sorts it by eigenvalue in ascending order
% % (because sortrows() hasn't a descending order option)
% lambdas = diag(D);
% %> keyboard;
% lambdas(:, 2) = (1:no_lambdas)';
% lambdas = sortrows(lambdas);
% 
% % sweeps the [lambda, index] table backwards in search for no_classes-1
% % largest and properly numeric eigenvalues
% W_star = zeros(nf, no_lambdas);
% lambdas2 = zeros(no_lambdas, 1);
% no_found = 0;
% for i = no_lambdas:-1:1
%     lambda = lambdas(i, 1);
%     if lambda ~= NaN & lambda ~= Inf & lambda > 0
%         no_found = no_found+1;
%         
%         v_temp = V(:, lambdas(i, 2));
%         W_star(:, no_found) = v_temp/norm(v_temp);
%         lambdas2(no_found) = lambdas(i, 1);
%     end;
% end;
% 
% if flag_sphere
%     W_star = V_*W_star;
% end;
% 
% if flag_pca
%     W_star = loadings_pca*W_star;
% end;
% 
% % % % % % % % % % Don't mess here again, JULIO, this needs to be like that, unnormalized
% % % % % % % % % % W_star = adjust_unitnorm(W_star);
% W_star = adjust_turn(W_star);
% 
% 
% 
% 
% if nargout() == 2
%   varargout(1) = {lambdas2}; 
% end;
% 
% fprintf('INFO: F-LDA applied (pre-processing: ''%s'').\n', s);
