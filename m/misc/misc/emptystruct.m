%>@ingroup misc
%>@file
%>@brief Creates empty structure with fields as in passed structure

%> @param st Struct with fields to be used to create the empty struct, OR cell array of field names (as strings)
function out = emptystruct(st)

if iscell(st)
    ff = st;
else
    ff = fields(st);
end;

out = struct.empty();
for i = 1:numel(ff)
    [out(:).(ff{i})] = deal();
end;
