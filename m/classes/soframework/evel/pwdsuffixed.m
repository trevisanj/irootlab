%> Inserts the pwd() suffix at the end of filename(s)
function fn = pwdsuffixed(fn)

flag_cell = iscell(fn);

if ~flag_cell
    fn = {fn};
end;

for i = 1:numel(fn)
    [path, name, ext] = fileparts(fn{i});
    fn{i} = fullfile(path, [name, '_', get_pwdsuffix(), ext]);
end;

if ~flag_cell
    fn = fn{1};
end;


