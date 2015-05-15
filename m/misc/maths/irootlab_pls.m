%>@ingroup maths
%>@file
%>@brief Partial Least Squares
%>
%> PLS according to [1]. <b>This PLS works with one response variable only</b> (which is typically the class - sometimes called PLSDA (PLS Discriminant Analysis)).
%>
%> <h3>Reference:</h3>
%> [1] Hastie, The elements of Statistical Learning, 2001, Algorithm 3.2, p.68
%
%> <b>Important: X-variables (columns of X) need to be standardized, otherwise the function will give an error.</b>
%
%> @param X "Predictor" variables
%> @param Y "Response" variable. <b>This PLS works with one variable only!</b>
%> @param no_factors Number of variables to be calculated.
%> @return <code>[loadings]</code> or <code>[loadings, scores]</code>
function varargout = irootlab_pls(X, Y, no_factors)

if ~exist('no_factors', 'var')
    no_factors = 1;
end;


% Y = data_normalize(Y, 's');

% According to Hastie, the X-variables need to be standardized. This is not a general requirement of PLS, but only for
% the version applied here.
assert_standardized(X, 0.02);

[no, nf] = size(X);
p = min(no_factors, nf);

L = zeros(nf, p);


% penalty
if 1
    M = eye(nf, nf);
else
    % Kromer, Boulesteix, Tutz: Penalized Partial Least Squares Based on B-Splines Transformations
    % http://epub.ub.uni-muenchen.de/1853/1/paper_485.pdf
    % a nice and clear paper
    dcoeff = [1, 10, 10]*no;
    P = zeros(nf, nf);
    for i = 1:length(dcoeff)
        D = diff_operator(nf, i-1);
        P = P+dcoeff(i)*(D'*D);
    end;
    
    M = inv(P);
end;




for m = 1:p
    % Coefficients are correlations between X and Y
    L(:, m) = M*X'*Y;
    
    z = X*L(:, m);
    
    % Makes columns in X orthogonal to the newfound z.

    for j = 1:nf
        X(:, j) = X(:, j)-z*(z'*X(:, j)/(z'*z));
    end;
end;


% [XL, YL, XS, YS] = plsregress(X, Y, no_factors);

L = adjust_unitnorm(L);

if nargout == 1
    varargout = {L};
else
    varargout = {L, X*L};
end;
