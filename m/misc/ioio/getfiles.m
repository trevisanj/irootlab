%>@file
%>@brief File list getter (not recursive)
%> @ingroup ioio
%>
%> @param wild ='*'. E.g. '*.mat'
%> @param patt_match (regular expression) If specified, directories will have to match this pattern
%> @param patt_exclude (regular expression) If specified, directories will have NOT TO match this pattern
%> @return list
function names = getfiles(wild, patt_match, patt_exclude)

if nargin < 1
    wild = '*';
end;
if nargin < 2
    patt_match = [];
end;
if nargin < 3
    patt_exclude = [];
end;
flag_match = ~isempty(patt_match);
flag_exclude = ~isempty(patt_exclude);

d = dir(wild);
names = {d.name};

if flag_match
    names = names(cellfun(@(x) ~isempty(x), regexp(names, patt_match, 'start')));
end;
if flag_exclude
    names = names(cellfun(@isempty, regexp(names, patt_exclude, 'start')));
end;
