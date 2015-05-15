%>@ingroup conversion groupgroup
%>@file
%>@brief Renumbers group indexes according to a different dataset
%>
%> This function uses group codes to match groups across datasets. indexes_orig contains group indexes that
%> correspond to data_orig. indexes_orig refer to unique(data_orig.groupcodes). The resulting indexes will refer to
%> unique(data_ref.groupcodes)
%>
%> If a group existes in data_orig but not in data_ref, an error will be generated.
%
%> @param indexes_orig This is a selection of groups to be dealt with; indexes point to <code>unique(data_orig.groupcodes)</code>
%> @param data_orig Original dataset
%> @param data_ref Reference dataset
%> @return Renumbered indexes
function indexes = renumber_group_indexes(indexes_orig, data_orig, data_ref)

codes_orig = unique(data_orig.groupcodes);
codes_ref = unique(data_ref.groupcodes);
no_indexes = length(indexes_orig);
indexes = zeros(1, no_indexes);

v = 1:length(codes_ref);

for i = 1:no_indexes
    idxnew = v(strcmp(codes_orig{indexes_orig(i)}, codes_ref));
    if isempty(idxnew)
        error('Colony code ''%s'' not found in reference dataset!', codes_orig{indexes_orig(i)});
    end;
    
    indexes(i) = idxnew; % idxnew can't have more than 1 element
end;
