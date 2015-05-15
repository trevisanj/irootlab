%> @ingroup conversion classlabelsgroup
%> @file
%> @brief Converts class maps to observation maps
%>
%> <b>Please note that @c classmaps is 1-based and @c classes is 0-based!</b>
%
%> @param classmaps cell of vectors containing class indexes
%> @param classes Vector of classes, probably a @c classes property of an @ref irdata object.
%> @return obsmaps
function obsmaps = classmap2obsmap(classmaps, classes)

no = numel(classes);
[ni, nj] = size(classmaps);
obsmaps = cell(ni, nj);
for i = 1:ni
    for j = 1:nj
        map = classmaps{i, j};
        boolmap = zeros(1, no);
        for k = 1:numel(map)
            boolmap = boolmap | (classes == map(k)-1)';
        end;
        obsmaps{i, j} = find(boolmap);
    end;
end;
