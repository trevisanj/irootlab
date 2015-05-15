%>@ingroup codegen
%> @file
%> @brief Variable names in workspace matching class
%>
%> @param classname Class to match
%> @param input (optional) (may be either a string with a class name or an instance of such class) 
%>        Input class to match. This is applicable only if @c classname is "block" or descendant, and is not checked,
%>        i.e., there will be an error if you specify input but classname is not the name of a block descendant
%> @return A cell of string containing the names of the variables in the workspace that match @c classname
function vars = get_varnames(classname, input)
if ~iscell(classname)
    classname = {classname};
end;
flag_input = nargin > 1 && ~isempty(input);
if flag_input && ischar(input)
    input = eval([input, '();']); % Creates instance of class whose name was given by input
end;    
vars0 = evalin('base', 'who');
n = numel(vars0);

flag_progress = n > 100;

if flag_progress
    ipro = progress2_open('GET_VARNAMES', [], 0, n);
end;

vars = {};
for i = 1:n
    if ~ismember(get_excludevarnames(), vars0{i}) %> operational names such as 'o' are excluded from list
        var = evalin('base', [vars0{i}, ';']);
        if sum(arrayfun(@(cn) isa(var, cn{1}), classname)) > 0
            if ~flag_input
                flag_continue = 1;
            else
                ic = var.inputclass;
                if ~iscell(ic)
                    ic = {ic};
                end;
                flag_continue = any(cellfun(@(x) isa(input, x), ic));
            end;
            
            if flag_continue
                vars{end+1} = vars0{i};
            end;
        end;
    end;
    
    if flag_progress
        ipro = progress2_change(ipro, [], [], i);
    end;
end;

if flag_progress
    progress2_close(ipro);
end;