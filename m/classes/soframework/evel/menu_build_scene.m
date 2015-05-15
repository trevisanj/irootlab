%> This function depends on a file called "scenesetup.m" which must create a scenebuilder variable called "a"
function menu_build_scene()
scenesetup;
a.boot();
while 1
    a.report_scene();
    option = menu(sprintf('Scene building menu for scene "%s"', a.scenename), ...
        {'Build everything', ...
         'Create .m files only', ...
         'Create scene in database only', ...       
         'Create sub-datasets only', ...
         'Delete scene from database', ...
         'Check tasks to create', ...
        }, 'Cancel', 0);
    try
        switch option
            case 1
                if confirm()
                    a.go();
                end;
            case 2
                if confirm()
                    a.save_files();
                end;
            case 3
                if confirm()
                    a.write_database();
                end;
            case 4
                if confirm()
                    a.create_datasplits();
                end;
            case 5
                if confirm()
                    a.delete_scene();
                end;
            case 6
                a.check_tasks();
            case 0
                break;
        end;
    catch ME
        % Displays error and goes back to menu
        fprintf(2, strrep(ME.getReport(), '%', '%%')); % displays in red
    end;        
end;

%------
function flag = confirm()
flag = strcmp(input('Please type "yes" to confirm: ', 's'), 'yes');