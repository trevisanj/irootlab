%> This function depends on a file called "scenesetup.m" which must create a scenebuilder variable called "a"
function menu_build_reports()
scenesetup;
% a.boot();
r = reportbuilder();
while 1
%     try
%         a.report_scene();
%     catch ME
%         disp(['Scene report not available: ', ME.message]);
%     end;
    r.print_status();
    option = menu(sprintf('Report building menu for scene "%s"', a.scenename), ...
        {'Run/Continue', ...
         'Reset', ...
         'Rebuild list', ...
         'Choose report types', ...
        }, 'Cancel', 0);
    try
        switch option
            case 1
                r = r.go();
                if r.flag_finished
                    disp('Bye :)');
                    break;
                end;
            case 2
                r = r.reset();
            case 3
                r = r.rebuild();
            case 4
                while 1
                    [z, flags, titles] = r.get_map2();
                    for i = 1:numel(flags)
                        oo{i} = sprintf('%s %s', iif(flags(i), 'ON ', 'off'), titles{i});
                    end;
                    opt2 = menu('Select to switch on/off', oo, 'Back', 0);
                    if opt2 == 0
                        break;
                    end;
                    r = r.set_flag_map2(opt2, ~flags(opt2));
                end;
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