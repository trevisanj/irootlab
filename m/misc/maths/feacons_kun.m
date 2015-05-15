%>@ingroup maths
%> @file
%> @brief Kuncheva's feature consistency index
%>
%> <h3>References</h3>
%>
%> ﻿Kuncheva, L. I. A stability index for feature selection, 390-395.
%>
%> @param s1 subset 1 of feature indexes
%> @param s2 subset 2 of feature indexes
%> @param nf Total number of possible features
function y = feacons_kun(s1, s2, nf)

k = numel(s1);

if numel(s2) ~= k
    irerror('Two subsets must have same number of elements!');
end;

if nf < k
    irerror('Number of features must be >= subset cardinality!');
end;


% The below is around 4.8 times faster than r = numel(intersect(s1, s2));
%
%  [A, B] = meshgrid(s1, s2);
%  temp = A == B;
%  r = sum(temp(:) & 1)/2; 
%
% However, this is around 14-15 times faster than r = numel(intersect(s1, s2))
s1 = s1(:);
s2 = s2(:)';
n1 = length(s1);
n2 = length(s2);
temp = s1(:, ones(1, n2)) == s2(ones(1, n1), :);
r = sum(temp(:) & 1);
    

a = k^2/nf;
y = (r-a)/(k-a+realmin);