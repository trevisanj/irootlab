%>@ingroup conversion classlabelsgroup
%>@file
%>@brief Renumbers vector in descending order of occurences of its elements. Leaves elements which are <= 0 alone.
%>
%> Re-numbering occurs so as to remove gaps in the original sequence.
%>
%> @warning Operates zero-based
%>
%> @sa blmisc_classes_from_clus, vis_image, vis_image_cat
%
%> @param y
%> @return <code>[z]</code> or <code>[z, neworder]</code>
function varargout = renumber_vector_idooo(y)

y = y(:);

b_obsidxs = y >= 0;

y2 = y(b_obsidxs);

nums = unique(y2);
counts = diff(find([1, diff(sort(y2')), 1])); % Finds how many times each number appears
[dummy, neworder] = sort(counts, 'descend');


z2 = y2;

for i = 1:numel(neworder)
    z2(y2 == nums(neworder(i))) = nums(i); %i-1;
end;

z = y;
z(b_obsidxs) = z2';

if nargout == 1
    varargout = {z};
elseif nargout == 2
    varargout = {z, neworder};
end;
