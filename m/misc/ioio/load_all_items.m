%>@ingroup ioio misc
%>@file
%>@brief Loads all MAT files in current directory (that contain a "r" variable inside) into the workspace
%
%> @param patt_match If specified, directories will have to match this pattern
%> @param patt_exclude If specified, directories will have NOT TO match this pattern
function load_all_items(patt_match, patt_exclude)
if nargin < 1
    patt_match = [];
end;
if nargin < 2
    patt_exclude = [];
end;
names = getfiles('*.mat', patt_match, patt_exclude);
n = numel(names);

for i = 1:n
    load_soitem(names{i});
end;

evalin('base', 'global TEMP; clear TEMP;');