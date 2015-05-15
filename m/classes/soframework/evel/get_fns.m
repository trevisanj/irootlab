%> Returns a list of output filenames
%> @param token Part of file name such that it starts as "output"<token>
%> @param s_exclude string of cell of strings to filter out the files that have any of them as part of their names
function c = get_fns(token, s_exclude)
d = dir(['output_', token, '*.mat']);


c = {d.name};

if nargin > 1
    if ischar(s_exclude)
        s_exclude = {s_exclude};
    end;
    
    for i = 1:numel(s_exclude)
        c(cellfun(@(x) any(strfind(x, s_exclude{i})), c)) = [];
    end;
end;
        
