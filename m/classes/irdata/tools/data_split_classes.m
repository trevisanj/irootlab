%> @ingroup datasettools
%> @file
%> @brief Splits data according to classes. Returns an array of structures.
%>
%> Split_classes separates data according to the class of each
%> instance. Instances are the rows of 'data'.

%> @param data irdata object
%> @param hierarchy classlabel levels to be taken into account
%>
%> @return <em>[pieces]</em> or <em>[pieces, map]</em>. @c pieces: array of irdata objects; @c map cell array of vectors containing the
%> indexes of the rows in the original dataset that went to each element of piece.
function varargout = data_split_classes(data, hierarchy)

if sum(data.classes < 0) > 0
    irwarning('Dataset has negative classes which will be ignored!');
end;

if data.nc == 0
    out = data;
    obsmaps = {1:data.no};
else
    
    if ~exist('hierarchy', 'var')
        hierarchy = []; % means maximum possible
    end;

    cellmap = classlabels2cell(data.classlabels, hierarchy);
    idxs_cl_new = cell2mat(cellmap(:, 4));
    no_classes = max(idxs_cl_new)+1;
    classmaps = cell(1, no_classes);
    for i = 1:no_classes
        classmaps{i} = find(idxs_cl_new == i-1);
    end;



    obsmaps = classmap2obsmap(classmaps, data.classes);
    out = data.split_map(obsmaps);
end;

if nargout == 1
    varargout = {out};
else
    varargout = {out, obsmaps};
end;
