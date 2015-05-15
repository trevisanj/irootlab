% function make_release(flag_make_doc=0, flag_clean=1, flag_delete_fuzzy=1, flag_delete_soframework=0)
%
% This is a MATLAB script created to make a new release of IRootLab.
%
% It will create a directory outside the "root" folder (where this file is in),
% Called "../irootlab-<version>", where <version> will be picked by executing the file "irootlab_version.m" inside the "trunk" folder
%
% The steps are:
% 1 Copy the whole "trunk" folder to "../irootlab-"<version>
% 2 Call Doxygen to make fresh documentation (should update the contents of the "../last-generated-doc" directory)
% 3 Copy whatever is inside "../last-generated-doc" to "../irootlab-<version>/doc"
% 4 Zips the folder into "../irootlab-"<version> "../../irootlab_releases"
%
% Parameters:
%   flag_make_doc=0 - whether to perform steps 2 and 3 above
%   flag_clean=1 - whether to delete the folder created in step 1 after copying the zip file
%   flag_delete_fuzzy=1 - whether to delete the folder containing the fuzzy classifier files
%   flag_delete_soframework=0 - whether to delete the "classes/soframework" folder
function make_release(flag_make_doc, flag_clean, flag_delete_fuzzy, flag_delete_soframework)

if nargin < 1 || isempty(flag_make_doc)
    flag_make_doc = 0;
end;

if nargin < 2 || isempty(flag_clean)
    flag_clean = 1;
end;

if nargin < 3 || isempty(flag_delete_fuzzy)
    flag_delete_fuzzy = ~any(strfind(irootlab_version, 'julio'));
end;

if nargin < 4 || isempty(flag_delete_soframework)
    flag_delete_soframework = 0;
end;


addpath('./m'); % To call irootlab_version;
sversion = irootlab_version();
basename = ['irootlab-', sversion, iif(flag_make_doc, '', '-nodoc')];
sdir = ['../../', basename];
disp(['Version is "', sversion, '"']);

% Step 0.1 - recompiles CLASSMAP.mat
classmap_compile();

% Step 0.2 - remakes classcreator.m
make_classcreator();


% Step 1
disp('Copying IRootLab m folder...');
copyfile('./m', sdir);



% Step 1.1 - removing all the ".svn" directories
disp('Removing ".svn" folders...');
tmp = pwd();
cd(sdir);
dirs = getdirs(pwd, {pwd});
for i = 1:numel(dirs)
    cd(dirs{i});
    if exist('.svn')
        rmdir('.svn', 's');
    end;
end;
cd(tmp);




% % Step 1.5 - encrypt Fuzzy classifier
% disp('Encrypting fuzzy classifier...');
% tmp = pwd();
% cd([sdir, '/classes/block/clssr/frbm']);
% pcode('*.m');
% delete('*.m');
% cd(tmp);

% Step 1.5 - delete Fuzzy classifier files
if flag_delete_fuzzy
    tmp = pwd();
    cd([sdir, '/classes/block/clssr/frbm']);
    pcode('*.m');
    delete('*.m');
    cd(tmp);
end;

% Step 1.6 - deletes the soframework
if flag_delete_soframework
    tmp = pwd();
    cd([sdir, '/classes/soframework']);
    delete('*.m');
    cd(tmp);
end;
















if flag_make_doc
    % Step 2
    disp('Running Doxygen...');
    cd('doxy');
    !doxygen
    cd('..');

    % Step 3
    disp('Copying IRootLab documentation folder...');
    copyfile('../../last-generated-doc', [sdir, '/doc']);
end;

% Step 4
zipfile = ['../../../../../irootlab_releases/', basename, '.zip'];
disp(['Creating zip file ', zipfile, '...']);
zip(zipfile, basename, '../..');

if flag_clean
    disp(['Deleting directory ', sdir, ' ...']);
    rmdir(sdir, 's');
end;

disp('Finished!');
    