%> @ingroup guigroup
%> @file
%> @brief Asks uses to type in dataset class levels (for varying purposes).
%> @image html Screenshot-ask_hierarchy.png

%> @param data Dataset (@ref irdata object)
%> @param title Dialog title
%> @param flag_all Whether to allow "all" (empty vector) option.
%> @return A structure containing the following fields: @c params; @c flag_ok
function result = ask_hierarchy(data, title, flag_all)
result.flag_ok = 0;

cc = classlabels2cell(data.classlabels);

s_all = '';
if flag_all
    s_all = ' ([] = all)';
end;
no_levels = size(cc, 2)-4;
s_plural = '';
if no_levels ~= 1
    s_plural = 's';
end;
    
while 1
    p = inputdlg(sprintf('Enter class levels to keep (dataset has %d level%s)%s', no_levels, s_plural,  s_all), title, 1, {'[]'});
    if ~isempty(p)
        flag_error = 0;
        try
            idxs = eval(p{1});
        catch me
            irerrordlg(me.message, 'Error');
            flag_error = 1;
        end;
        
        if ~flag_error
            if ~isnumeric(idxs)
                irerrordlg('Please type in a numerical vector!', 'Invalid input');
                flag_error = 1;
            elseif ~flag_all
                % If all not allowed, check if user specified all
                if isempty(idxs)
                    irerrordlg('Empty vector not allowed!', 'Invalid input');
                    flag_error = 1;
                end;
            end;
        end;
        
        % Does not check if levels are valid, maybe that's too much, let error occur
       
        if ~flag_error
            result.params = {'hierarchy', mat2str(idxs)};
            result.flag_ok = 1;
            break;
        end;
    else
        if iscell(p)
            % inputdlg returns an empty cell when cancelled
            result.flag_ok = 0;
            break;
        else
            irerrordlg('Please specify', 'Invalid input');
        end;
    end;
end;

