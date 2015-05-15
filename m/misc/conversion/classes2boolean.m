%> @ingroup conversion classlabelsgroup
%> @file
%> @brief Converts classes into a boolean matrix.
%>
%> Converts classes into a boolean matrix where each column correspond to one class. It will contain a one in column j
%> if the i-th row belongs to the j-th class or zero otherwhise. 
%
%> @param classes Zero-based class vector. It may be a column or row vector, doesn't matter. 
%> @param no_different =(auto) Number of classes
%>
%> @return output Matrix described below.
function output = classes2boolean(classes, no_different)

if ~exist('no_different', 'var')
    no_different = max(classes >= 0)+1; %> number of classes
end;
len = length(classes);
output = zeros(len, no_different);

for i = 1:len
    if classes(i) >= 0
        output(i, classes(i)+1) = 1;
    end;
end
