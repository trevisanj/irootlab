%> @ingroup datasettools
%> @file
%> @brief Draws covariance matrix
%> @sa draw_covariance.m
%
%> @param data
%> @param which 'c': covariance; 'w': within-class scatter matrix; 'b': between-class scatter matrix
%> @param y_ref =mean(X, 1) The "hint curve"
%> @param flag_inv Whether to invert before drawing
function data = data_draw_covariance(data, which, y_ref, flag_inv)

if ~exist('which', 'var')
    which = 'c';
end;

if nargin < 4 || isempty(flag_inv)
    flag_inv = 0;
end;

X = data.X;

if ~exist('y_ref', 'var')
  y_ref = mean(X, 1);
end;

no = size(X, 1);
if which == 'c'
    C = cov(X);
else
    [SB, SW] = data_calculate_scatters(data, 0, 0);
    
    if which == 'w'
        C = SW;
    else
        C = SB;
    end;
%     C = C/no;
end;

if flag_inv
    C = inv(C);
end;

draw_covariance(C, data.fea_x, y_ref);
