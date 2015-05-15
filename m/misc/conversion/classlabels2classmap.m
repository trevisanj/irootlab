%> @ingroup conversion classlabelsgroup
%> @file
%> @brief Creates class map from a list of class labels
%>
%> This functions searches from a list of labels within the @c classlabels complete list and returns their indexes. It can also work in complement mode (xor with complete list). It searches within one combination of class levels.
%
%> @param classlabels Full list of class labels
%> @param classlabels_select Class labels to be selected
%> @param levels Combination of levels (won't do search within individual levels, but will instead assume that the elements inside @c classlabels_select) are made to match elements of classlabels when they are re-mounted taken into account @c levels only
%> @param flag_complement =0 Option to return the complement classes instead
%> @return idxs
function idxs = classlabels2classmap(classlabels, classlabels_select, levels, flag_complement)



cellmaps = classlabels2cell(classlabels, levels);

nl = numel(classlabels_select);

idxs = [];
for i = 1:nl
    idxs = [idxs, find(strcmp(classlabels_select, cellmaps(:, 3)))];
end;

if flag_complement
    idxs = setxor(idxs, 1:size(cellmaps, 1));
end;
% varnames = unique(cellmaps(:, 3));
% o = classsplitter();
% o.classlabels = classlabels;
% o.hie_base = hie_base;
% o.hie_split = hie_split;
% for i = 1:numel(varnames)
%     o = o.set_baselabel(varnames{i});
%     eval([varnames{i} ' = o;']);
% end;
% 
% for i = 1:numel(ss)
%     oo = eval(ss{i});
%     maps{i} = oo.map;
% end;
% 
% 
%     
