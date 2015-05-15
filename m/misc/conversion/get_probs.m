%>@ingroup conversion maths
%>@file
%>@brief Calculates per-class probabilities by counting the number of occurences for each class
%
%> @param classes Zero-based class vector. It may be a column or row vector, doesn't matter. 
%> @param no_different =(auto) Number of classes. This can be correctly inferred only if the maximum possible class is present within @c classes.
%>
%> @return <code>[probs]</code> or <code>[probs, numbers_of_occurences]</code>
function varargout = get_probs(classes, no_different)

if ~exist('no_different', 'var')
    no_different = max(classes)+1; %> number of classes
end;

% Transposes if needed
[nr, nc] = size(classes);
if nr > nc
    classes = classes';
end

sorted = sort(classes);
poss = find([1, diff(sorted), 1]);
no_occurences = diff(poss);
occur = zeros(1, no_different);
if ~isempty(classes)
    occur(sorted(poss(1:end-1))+1) = no_occurences;
end;

probs = occur/(numel(classes)+realmin);
if nargout == 1
    varargout = {probs};
else
    varargout = {probs, occur};
end;

