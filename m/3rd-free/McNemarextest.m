%> @file
%> @brief McNemar test
%>
%> !!!!!!! 1-tail not working!!! I don't know how to calculate this and all examples I found use the 2-tailed formula anyway
%>
%> <h3>Meaning of the elements of vector @c v</h3>
%>
%> In the explanation below, C1 stands for "classifier 1", and C2 stands for "classifier 2"
%>
%> Number of test examples ...
%> @arg N11: ... correctly classified simultaneously by C1 and C2
%> @arg N10: ... correctly classified by C1 but not C2
%> @arg N01: ... correctly classified by C2 but not C1
%> @arg N00: ... wrongly classified simultaneously by C1 and C2
%>
%> Note that N11+N10+N01+N00 = number of examples in the test set.
%>
%> <b>Note</b> that N11 and N00 are not used!!!
%>
%> This function was originally created by Trujillo-Ortiz, Hernandez-Walls and Castro-Perez and was found in MATLAB file central. It was
%> modified to:
%> @arg return results rather than display them
%> @arg contain help text targeting classifier comparison and in Doxygen format
%> @arg only the "Chi-squared and corrected for discontinuity" version remains as it is compliant with [1]
%>
%> <h3>References</h3>
%>
%> [1] Kuncheva, II. "Combining Pattern Classifiers", Wiley, 2004.
%>
%>
%> <h3>Credits</h3>
%>  Created by A. Trujillo-Ortiz, R. Hernandez-Walls and A. Castro-Perez
%>             Facultad de Ciencias Marinas
%>             Universidad Autonoma de Baja California
%>             Apdo. Postal 453
%>             Ensenada, Baja California
%>             Mexico.
%>             atrujo@uabc.mx
%>  Copyright (C) November 5, 2004.
%>
%>  $$Authors thank the valuable to-improve comments on the m-file review given
%>    by I.Y., dated 2006-05-23. Modified lines are 138-143$$ 
%>
%>  To cite this file, this would be an appropriate format:
%>  Trujillo-Ortiz, A., R. Hernandez-Walls and A. Castro-Perez. (2004).
%>    McNemarextest:McNemar's Exact Probability Test. A MATLAB file. [WWW document].
%>    URL http://www.mathworks.com/matlabcentral/fileexchange/6297
%>
%>  References from the original file:
%> 
%>  Hollander, M. and Wolfe, D.A. (1999), Nonparametric Statistical Methods (2nd ed.).
%>        NY: John Wiley & Sons. p. 468-470.
%>
%>  McNemar, Q. (1947), Note of the sampling error of the difference between 
%>        correlated proportions or percentages. Psychometrika, 12:153-157.

%> @param v Vector: <code>[N11, N10, N01, N00]</code> (see text).<b>Note</b> that N11 and N00 are not used!!!
%> @param tails=2 One or Two tails (1 or 2) (see text)
%> @param alpha=0.05 Significance level
%> @return The p-value
function p = McNemarextest(v,tails,alpha)
%MCNEMAREXTEST McNemar's Exact Test.
%
%   MCNEMAREXTEST, performs the conditional as well as the Chi-squared 
%   corrected for discontinuity McNemar's exact test for two dependent 
%   (correlated) samples that can occur in matched-pair studies with a 
%   dichotomous (yes-no) response. Dependent samples can also occur when
%   the same subject is measured at two different times. It tests the null
%   hypothesis of marginal homogeneity. This implies that rows totals are
%   equal to the corresponding column totals. So, since the a- and the 
%   d-value on both sides of the equations cancel, then b = c. This is the
%   basis of the proposed test by McNemar (1947). The McNemar test tests the
%   null hypothesis that conditional on b + c, b has a binomial (b + c, 1/2)
%   distribution.
%
%   According to the next 2x2 table design,
%
%                   Sample 1
%                --------------
%                  Y        N
%                --------------
%             Y    a        b      r1=a+b
%   Sample 2
%             N    c        d      r2=c+d
%                --------------
%                c1=a+c   c2=b+d  n=c1+c2
%
%    (Y = yes; N = no)
%
%   The proper way to test the null hypothesis is to apply the one-sample
%   binomial test. If there is no association between b and c values, then
%   the probability is 0.5 that the sample 1 and sample 2 pair falls in the 
%   upper-right cell and 0.5 that it falls in the lower-left cell, given
%   that the pair falls off the main diagonal.
%
%   Syntax: function McNemarextest(v,tails,alpha) 
%      
%   Inputs:
%         v - data vector defined by the observed frequency cells [a,b,c,d].
%         tails - desired test [tails = 1, one-tail; tails = 2, two-tail (default)].
%     alpha - significance level (default = 0.05).
%
%   Output:
%         A table with the proportion of success for the dependent samples
%           and the P-value. 
%
%   Example: From the example on Table 10.5 given by Hollander and Wolfe (1999), in a
%            matched-pair study we are interested to testing by the McNemar's exact 
%            one-sided test the null hypothesis that the success for the dependent 
%            samples (sample 1 and sample 2) are equal. The data are given as follow.
%
%                                   Sample 1
%                            ---------------------
%                                Y            N
%                            ---------------------
%                      Y        26           15
%          Sample 2                 
%                      N         7           37
%                            ---------------------
%                                       
%            v = [26,15,7,37];
%
%   Calling on Matlab the function: 
%             McNemarextest(v,1,0.05)
%
%   Answer is:
%
%   Table for the McNemar's exact test.
%   -------------------------------------------
%         Proportion of success  
%   --------------------------------
%       Sample 1        Sample 2           P  
%   -------------------------------------------
%        0.3882          0.4824       0.066900
%   -------------------------------------------
%   For a selected one-sided test.
%   With a given significance of: 0.050
%   The test results not significative.
%
%   Table for the McNemar's test by the Chi-squared and
%   corrected for discontinuity.
%   -----------------------------------------------------------
%         Proportion of success  
%   --------------------------------
%       Sample 1        Sample 2           Chi2         P  
%   -----------------------------------------------------------
%        0.3882          0.4824           2.2273      0.135593
%   -----------------------------------------------------------
%   For a selected one-sided test.
%   With a given significance of: 0.050
%   The test results not significative.
% 
%

if length(v) ~= 4,
    error('Vector must have four data. The a,b,c,d entry for the 2x2 table.');
    return;
end

if ~all(isfinite(v(:))) || ~all(isnumeric(v(:)))
    error('All X values must be numeric and finite')
elseif ~isequal(v(:),round(v(:)))
    error('X data matrix values must be whole numbers')
end

if nargin < 3,
   alpha = 0.05;  %(default) 
elseif (length(alpha)>1),
   error('Requires a scalar alpha value.');
elseif ((alpha <= 0) || (alpha >= 1)),
   error('Requires 0 < alpha < 1.');
end

if nargin < 2, 
    tails = 2;  %two-tailed test 
end



N = v(2)-v(3);
D = v(2)+v(3);
if D == 0
    p = 1;
    irwarning('McNemar test with zero denominator');
else
    X2 = N^2/D;
    X2c = (abs(N)-1)^2/D;

    if tails == 2
        p = 1-chi2cdf(X2c,1);
    else
        error('Sorry, 1-tail test not available');
        p = chi2cdf(-X2c, 1)/2;
    end;
end;


% disp(' ')
% disp('Table for the McNemar''s test by the Chi-squared and')
% disp('corrected for discontinuity.')
% fprintf('-----------------------------------------------------------\n');
% disp('  Chi2         P  '); 
% fprintf('-----------------------------------------------------------\n');
% fprintf('%10.4f      %5.6f\n',[X2c,p].');
% fprintf('-----------------------------------------------------------\n');
% if tails == 1
%     disp('For a selected one-sided test.')
%     fprintf('With a given significance of: %.3f\n', alpha);
%     if p > alpha;
%         disp('The test results not significative.')
%     else p <= alpha;
%         disp('The test results significative.')
%     end
% else tails == 2;
%     disp('For a selected two-sided test.')
%     fprintf('With a given significance of: %.3f\n', alpha/2);
%     if p > alpha/2;
%         disp('The test results not significative')
%     else p <= alpha/2;
%         disp('The test results significative')
%     end
% end
% disp(' ')

return;
