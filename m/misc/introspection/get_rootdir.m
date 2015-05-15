%> @file
%> @ingroup introspection
%> @brief Returns the root directory

function s = get_rootdir()
a = which('irootlab');
if isempty(a)
    irerror('irootlab.m not found');
end;

poss = find(a == filesep);

s = a(1:(poss(end-1)-1));