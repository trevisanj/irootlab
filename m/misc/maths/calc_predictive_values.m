%>@ingroup maths
%> @file
%> @brief Calculates predictive values
%> @code
%> P(a|A) = P(A|a)*P(a)/P(A)
%> @endcode
%> However this formula is not used, because it is easier to use a column of the confusion matrix
%>
%> P(a|A) is the probability of belonging to
%> class 'a' given that you have been classified as so.
%
%> @param cc confusion matrix in HITS, NOT PERCENTAGE
%> @return \em values predictive values for each column of cc
function values = calc_predictive_values(cc)


no_classes = size(cc, 2);

values = zeros(1, no_classes);

for i = 1:no_classes
    
    % P(a|A) = P(A|a)*P(a)/P(A)
    %
    % P(A|a) = n_aA/n_a
    % P(a) = n_a/n
    % P(A) = n_A/n
    %
    % The formula simplifies to 
    % P(a|A) = n_aA/n_A
    values(i) = cc(i, i)/sum(cc(:, i));
end;
