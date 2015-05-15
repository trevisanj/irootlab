%>@ingroup datasettools
%> @file
%> @brief Merges several datasets into one (row-wise)
%>
%> The new dataset ('out') will be first created as a clone of datasets(1) however with the fields listed in datasets(1).rowfieldnames empty
%>
%> Needless say the datasets need to be column-compatible.

function out = data_merge_rows(datasets)

newlabels = unique_appear([datasets.classlabels]);

% prepares output based on first dataset
out = datasets(1).copy_emptyrows();
out.classlabels = newlabels;
% Prepares list of fields to merge, except for classes, which is a more complicated case
rr = datasets(1).rowfieldnames;
nr = numel(rr);
iclasses = find(strcmp('classes', rr));
nd = numel(datasets);

flags = ones(1, nr);
for i = 1:nr % Determines which fields to merge and which to ignore.
    for j = 1:nd
        if size(datasets(j).(rr{i}), 1) < datasets(j).no 
            % If a row field has less elements than the dataset's no property, the field is excluded from the merge.
            flags(i) = 0;
            break;
        end;
    end;
end;
            
% Pre-allocation
no_all = sum([datasets.no]);
for j = 1:nr
    if flags(j)
        if out.flags_cell(j)
            out.(rr{j}) = cell(no_all, size(datasets(1).(rr{j}), 2));
        else
            out.(rr{j}) = zeros(no_all, size(datasets(1).(rr{j}), 2));
        end;
    end;
end;
% out.classes = zeros(no_all, 1);


ptr = 1;
for i = 1:nd
    data = datasets(i);
    
    % Finds new class indexes
%     newidxs = zeros(1, data.nc);
    newclasses = data.classes;
    for j = 1:data.nc
        newclass = find(strcmp(data.classlabels{j}, newlabels))-1;
        newclasses(data.classes == j-1) = newclass;
    end;
    
    % merges the rowfieldnames fields (except 'classes')
    for j = 1:nr
        if flags(j)
            if j == iclasses
                out.classes(ptr:ptr+data.no-1, :) = newclasses;
            else
%             out.(rr{j}) = [out.(rr{j}); data.(rr{j})];
                out.(rr{j})(ptr:ptr+data.no-1, :) = data.(rr{j});
            end;
        end;
    end;
    ptr = ptr+data.no;
end;
