%> This function depends on a file called "scenesetup.m" which must create a scenebuilder variable called "a"
function menu_run_tasks()
scenesetup;
setup_load();
c = onCleanup(@()on_cleanup());
assert_connected_to_cells();
tm = taskmanager();
tm.scenename = a.scenename;
tm = tm.boot();
while 1
    a.report_scene();
    option = menu(sprintf('Tasks runner for scene "%s"', tm.scenename), { ...
        'Run until all tasks are completed', ...
        'Reset ongoing', ...
        'Reset failed', ...
        'Reset ongoing and failed', ...
        'Reset all'}, 'Cancel', 0);
    switch option
        case 1
    [o, idxs] = tm.run_until_all_gone();
    fprintf('Idxs run:\n%s\n', mat2str(idxs));
        case 2
            if confirm()
                tm.reset_ongoing();
            end;
        case 3
            tm.reset_failed();
        case 4
            if confirm()
                tm.reset_ongoing();
                tm.reset_failed();
            end;
        case 5
            if confirm()
                tm.reset_all();
            end;
        case 0
            break;
    end;
end;


%------
function on_cleanup()
db_reset(); % To avoid not finding SHEware DB if the user goes to objtool afterwards
disp('DB global was reset.')

%------
function flag = confirm()
flag = strcmp(input('Please type "yes" to confirm: ', 's'), 'yes');