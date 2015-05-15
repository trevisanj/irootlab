%> @file
%> @ingroup introspection
%> @brief Returns an array of mapitem objects matching the informed criteria
%> @sa objtool.m, blockmenu.m, demo_classes_txt.m
%
%> @param classname String containing the name of the root class
%> @param inputclass =[] Optional filter: if informed, only classes whose "inputclass" property match this parameter will be included in the result
%> @return \em [out] list array of mapitem objects
function list = classmap_get_list(classname, inputclass)
if ~exist('inputclass', 'var')
    inputclass = [];
end;
list = mapitem.empty;
classmap_assert();
global CLASSMAP;
item = CLASSMAP.find_item_by_name(classname);
if ~isempty(item)
    list = item.to_list(inputclass);
end;
