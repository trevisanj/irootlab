%> @ingroup conversion classlabelsgroup string
%> @file
%> @brief Parses expression into classmaps
%>
%> Facilitates generation of lists of sub-datasets -- specified by the classes that go into each -- using expression
%> strings.
%>
%> "Variables" in @c ss must match class labels from the @hie_base level. Expression will be evaluated using @c eval()
%> after creating @c classsplitter objects whose variable names match those of the class labels of the @hie_base level.
%>
%> Possible operators are "+", "-" (unary minus), and "~".
%>
%> <h3>Example:</h3>
%> @code
%> if flag_julio
%>     dslila = ul_load_data(1);
%>     ss = {'-JT', '~-JT'};
%> else
%>     dslila = ul_load_data(2);
%>     ss = {'-AA', '~-AA'};
%> end;    
%> dslila = data_select_hierarchy(dslila, [1, 2, 3]);
%> HIE_DATA = 1;
%> HIE_SPLIT = 2;
%> classmaps = parse_classmaps(ss, dslila.classlabels, HIE_DATA, HIE_SPLIT);
%> no_cases = numel(classmaps{1});
%> @endcode
%>
%> @sa classsplitter
%
%> @param ss Cell of strings.
%> @param classlabels
%> @param hie_base hierarchical dataset level 
%> @param hie_split hierarchical split level
function maps = parse_classmaps(ss, classlabels, hie_base, hie_split)

cellmaps = classlabels2cell(classlabels, hie_base);
varnames = unique(cellmaps(:, 3));
o = classsplitter();
o.classlabels = classlabels;
o.hie_base = hie_base;
o.hie_split = hie_split;
for i = 1:numel(varnames)
    o = o.set_baselabel(varnames{i});
    eval([varnames{i} ' = o;']);
end;

for i = 1:numel(ss)
    oo = eval(ss{i});
    maps{i} = oo.map;
end;


    
