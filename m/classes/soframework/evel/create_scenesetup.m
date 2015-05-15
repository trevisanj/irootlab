%> @file
%> @ingroup soframework
%
%> @brief Creates file "scenesetup.m" in current directory
function create_scenesetup()
fn = fullfile(pwd, 'scenesetup.m');
if exist(fn, 'file')
    opt = input('File "scenesetup.m" already exists. Type "yes" to overwrite: ', 's');
    if ~strcmp(opt, 'yes')
        disp('Not doing anything');
        return;
    end;
end;
[p, f, e] = fileparts(mfilename('fullpath')); %#ok<*NASGU,*ASGLU>
h = fopen(fullfile(p, 'template_scenesetup.m'), 'r');
fgets(h); % skip first line
S = fread(h, 'char');
fclose(h);

h = fopen(fn, 'w');
fwrite(h, ['% scenesetup.m file Created at ', datestr(now), 10]);
fwrite(h, S);
fclose(h);
disp(['File ``<a href="matlab:edit(''', fn, ''')">', fn, '</a>`` created.']);
