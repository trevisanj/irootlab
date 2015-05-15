%>@brief Text-based menu
%>@file
%>@ingroup string usercomm
%
%> @param title
%> @param options Cell of strings
%> @param cancel_label ='Cancel'. Label to show at last "zero" option
%> @param flag_allow_empty =0 Whether to allow empty option
%> @return option An integer: []; 0-Back/Cancel/etc; 1, 2, ...
function option = menu(title, options, cancel_label, flag_allow_empty)

if nargin < 3 || isempty(cancel_label)
    cancel_label = 'Cancel';
end;

if ~exist('flag_allow_empty', 'var')
    flag_allow_empty = 0;
end;

no_options = length(options);

flag_ok = 0;
ch = 'O';
while 1
    fprintf('\n');
    fprintf(['  ' ch*ones(1, length(title)+8) '\n']);
    fprintf(['  ' ch*ones(1, 3) ' ' title ' ' ch*ones(1, 3) '\n']);
    fprintf(['  ' ch*ones(1, length(title)+8) '\n']);
    for i = 1:no_options
        fprintf('  %d - %s\n', i, options{i});
    end;
    fprintf('  0 - << (*%s*)\n', cancel_label);
    option = input('% ');
    
    n_try = 0;
    while 1
        if n_try >= 10
            fprintf('You are messing up');
            break;
        end;
        
        flag_no = 0;
        if isempty(option) && flag_allow_empty
            flag_ok = 1;
            break;
        end;
        for i = 1:length(option)
            if option(i) < 0 || option(i) > no_options
                flag_no = 1;
                break;
            end;
        end;
        if ~flag_no
            flag_ok = 1;
            break;
        end;
        
        fprintf('Invalid option, range is [%d, %d].', 0, no_options);
            
        n_try = n_try+1;
        option = input('% ');
        

    end;
    
    if flag_ok
        break;
    end;
end;


