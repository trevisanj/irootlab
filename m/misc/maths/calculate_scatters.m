%>@ingroup maths
%>@file
%>@brief Calculates scatter matrices from X and classes
%
%> @param X [no]x[nf] matrix
%> @param classes [no]x[1] matrix
%> @param flag_modified_s_b  if 1, S_B will be calculated in an alternative way which is class terms will not be weighet by class sample size, which
%> will cause all classes to have equal importance.
%> @param P penalty matrix to be added to @c S_W
%> @return <em>[S_B, S_W]</em> Respectively "inter-class scatter matrix" and "within-class scatter matrix"
function [S_B, S_W] = calculate_scatters(X, classes, flag_modified_s_b, P)

[no, nf] = size(X);

if ~exist('flag_modified_s_b', 'var')
    flag_modified_s_b = 0;
end;

if ~exist('P', 'var')
    P = 0;
else
    [q, w] = size(P);
    if q ~= nf || w ~= nf
        % assumes the coefficients have been passed
        P = no*penalty_matrix(nf, P);
    else
    end;
end;

m = mean(X); % total mean vector

no_classes = max(classes)+1;


S_W = zeros(nf, nf);
S_B = S_W;
for i = 1:no_classes
    Xi = X(classes == i-1, :);
    if size(Xi, 1) > 0
        m_i = mean(Xi); % vector containing the means for each column/feature.

        Xi = Xi-repmat(m_i, size(Xi, 1), 1); % centers each column to its mean

        n_i = size(Xi, 1); % number of observations for class i

        scatter = Xi'*Xi; % scatter matrix. This is S_i in the reference
        if flag_modified_s_b
            S_B = S_B+(m_i-m)'*(m_i-m); % last term is a rank-1 matrix (MATLAB's default is row vector)
        else
            S_B = S_B+n_i*(m_i-m)'*(m_i-m); % last term is a rank-1 matrix (MATLAB's default is row vector)
        end;
        S_W = S_W+scatter;
    end;
end;

if 0
    S_B = S_B-P;
else
    % I have found empirically that adding P to S_W is equivalent to adding
    % P to X'*X in canonical correlation analysis

    S_W = S_W+P;
    
%     S_W = eye(nf, nf);
end;
