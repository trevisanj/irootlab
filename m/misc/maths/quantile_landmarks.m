%>@ingroup maths
%>@file
%>@brief x-positions where quantiles occur.
%
%> @param I Obtained from an <code>integrate(X)</code>
%> @param par2 Number of quantiles, if a scalar, or the quantiles themselves (0 < value_i < 1), if a vector.
%> @param t_range for the final conversion of T's values to the proper scale. If not informed, it will be <code>[1, size(I, 2)]</code>
%> @return T
function T = quantile_landmarks(I, par2, t_range)

[no, no_t] = size(I);

if ~exist('t_range', 'var')
    t_range = [1, no_t];
end;

if length(par2) == 1
    no_quants = par2;
    quants = linspace(0, 1, no_quants+1);
    quants = quants(2:end);
else
    no_quants = length(par2);
    quants = par2;
end;

T = zeros(no, no_quants);
ii = 0;
for i = 1:no
    j = 1;
    vi = I(i, :)/I(i, end);
    
    % Interpolates the inverse of the integral function so now we'll be able to have a "quantile" function in functional
    % form
    
    % attempt 0 (didn't work)
% % % % % %     T(i, :) = spline(vi, 1:no_t, quants);

    % attempt 1 (bad fit)
% % % % % %     p  = polyfit(vi, 1:no_t, min(10, max(3, floor(no_t/20))));
% % % % % %     T(i, :) = polyval(p, quants);
% % % % % %     % Some bad interpolation in the begining can lead to tremendously negative numbers
% % % % % %     wrong = T(i, :) < 1;
% % % % % %     T(i, wrong) = 1;
% % % % % %     if sum(T(i, :) > 1000) > 0
% % % % % %         disp('porra, agora eh positivo!!!');
% % % % % %     end;
% % % % %     



    
    % attempt 2 (good but uses the spline toolbox)
    w = ones(1, length(vi)); w([1, end]) = 300;
    sp = spaps(vi, 1:no_t, 1, w, 1);  % perfect!!!
    T(i, :) = fnval(sp, quants);
    

    ii = ii+1;
    if ii > 500
        fprintf('. %g%%\n', i/no*100);
        ii = 0;
    end;
%     i_quant = 1;
%     while 1
%         if vi(j) >= quants(i_quant)
%             T(i, i_quant) = j;
%             i_quant = i_quant+1;
%         else
%             j = j+1;
%         end;
%         
%         if i_quant > no_quants
%             break;
%         end;
%         
%         if j > no_t
%             irwarning('Maybe not monotonic');
%             break;
%         end;
%     end;
end;
    
tf = t_range(2);
ti = t_range(1);

T = (T-1)*(tf-ti)/(no_t-1)+ti; % Normalizes warping information to the original number of features
