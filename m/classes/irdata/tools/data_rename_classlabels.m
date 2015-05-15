%>@ingroup datasettools classlabelsgroup
%> @file
%> @brief searches and replaces class labels
%>
%> This function performs the search within class levels, not the whole labels. For example, in a label 'A|B|C', matched will be tried against 'A', 'B', and 'C' separately
%>

%> @param data Dataset
%> @param map See syntax below: @code {old_label1, new_label1; old_label2, new_label2; ...} @endcode
%> @param levelstosearch Levels to search
%> @return Dataset with classlabels changed
function data = data_rename_classlabels(data, map, levelstosearch)

comoassim = classlabels2cell(data.classlabels);

if ~exist('levelstosearch', 'var') || isempty(levelstosearch)
    levelstosearch = 1:(size(comoassim, 2)-4); % all levels
end;

no_map = size(map, 1);

new = {};

for i = 1:data.nc
    flag_first = 1;
    s = '';
    for j = 5:size(comoassim, 2)
        if any(levelstosearch == j-4)
            for k = 1:no_map
                if strcmp(comoassim{i, j}, map{k, 1})
                    comoassim{i, j} = map{k, 2};
                end;
            end;
        end;

        if ~flag_first
            s = [s '|'];
        end;
        s = [s comoassim{i, j}];
        flag_first = 0;
    end;

    new{end+1} = s;
end;

data.classlabels = new;


