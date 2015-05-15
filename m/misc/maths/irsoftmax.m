%>@ingroup maths
%> @file
%> @brief "Softmax" Transformation
%>
%> Returns a matrix where each row sums to one and the elements are exponentially proportional to their respective originals
%>
%> <h3>Reference</h3>
%> Kuncheva, Combining Pattern Classifiers, 2004, section 5.1, page 152
%>
%> @sa clssr_ls
function Y = irsoftmax(X)

Xe = exp(X);
Y = Xe./(realmin+repmat(sum(Xe, 2), 1, size(Xe, 2)));

