%>@ingroup code guigroup
%>@file
%>@brief Renames object
%>
%> Actually a mix of GUI and code generation.
%
%> @param s
function rename_object(s)    
    
obj = evalin('base', [s, ';']);
classname = class(obj);

p = inputdlg(sprintf('Enter new name for %s object named ''%s''', classname, s), 'Rename object', 1, {s});
if ~isempty(p) && ~isempty(p{1})
    name_new = p{1};
    if strcmp(s, name_new)
        irerrordlg('Please type a different name!', 'Invalid name');
    else
        a = evalin('base', ['who(''' name_new ''');']);
        flag_ok = 1;
        if ~isempty(a)
            answer = questdlg(sprintf('Name ''%s'' already exists in the workspace. Overwrite variable?', name_new), 'Confirmation', 'Yes', 'No', 'No');
            if strcmp(answer, 'No')
                flag_ok = 0;
            end;
        end;

        if flag_ok
            code = sprintf('%s = %s;\nclear %s;\n', name_new, s, s);
            try
                ircode_eval(code, sprintf('Rename %s object', classname));
            catch ME
                irerrordlg(ME.message);
                rethrow(ME);
            end;
        end;
    end;
end;
