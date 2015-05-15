%> @ingroup misc introspection
%> @file
%>@brief Recursive directory structure getter
%>
%> @param direc A directory to query all subdirectories from
%> @param list (optional) An existing list to which new elements will be appended
%> @param patt_match If specified, directories will have to match this pattern
%> @param patt_exclude If specified, directories will have NOT TO match this pattern
%> @return list
function list = getdirs(direc, list, patt_match, patt_exclude)

if nargin < 1 || isempty(direc)
    direc = '.';
end;

if nargin < 2 || isempty(list)
    list = {};
end;

if nargin < 3
    patt_match = [];
end;
if nargin < 4
    patt_exclude = [];
end;
flag_match = ~isempty(patt_match);
flag_exclude = ~isempty(patt_exclude);

d = dir(direc);
d = {d([d.isdir]).name};
d = {d{~ismember(d,{'.' '..'})}};
if flag_match
    d = d(cellfun(@(x) ~isempty(x), regexp(d, patt_match, 'start')));
end;
if flag_exclude
    d = d(cellfun(@isempty, regexp(d, patt_exclude, 'start')));
end;
for j=1:length(d)
    if ~any(d{j}(1) == '@.')
        ff = fullfile(direc,d{j});
        list{end+1} = ff;
        list = getdirs(ff,list, patt_match, patt_exclude);
    end;
end

