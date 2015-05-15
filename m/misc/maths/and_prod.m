%> @ingroup maths
%> @file
%> @brief AND operator as a product
%
%> @param memberships [no_rules][nf] matrix
%> @return out [1][no_rules] vector
function out = and_prod(memberships)
out = prod(memberships, 2)';

