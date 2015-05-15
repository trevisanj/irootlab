%> Inserts the pwd() suffix at the beginning of filename(s)
function fn = pwdprefixed(fn)

flag_cell = iscell(fn);

if ~flag_cell
    fn = {fn};
end;

for i = 1:numel(fn)
    [path, name, ext] = fileparts(fn{i});
    fn{i} = fullfile(path, [get_pwdsuffix(1), '_', name, ext]);
end;

if ~flag_cell
    fn = fn{1};
end;


