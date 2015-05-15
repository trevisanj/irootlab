%>@ingroup codegen
%> @file
%> @brief Variable names in workspace matching class
%>
%> Returns a cell of cells of strings. Each inner cell will have all variables matching a corresponding element in @ref classnames
function vars = get_varnames2(classnames)
if ~iscell(classnames)
    classnames = {classnames};
end;
no_classes = numel(classnames);
vars0 = evalin('base', 'who');
n = numel(vars0);

flag_progress = n > 100;

if flag_progress
    ipro = progress2_open('GET_VARNAMES2', [], 0, n);
end;

vars = repmat({{}}, 1, no_classes);
for i = 1:n
    if ~ismember(get_excludevarnames(), vars0{i}) %> operational names such as 'o' are excluded from list
        var = evalin('base', [vars0{i}, ';']);
        matches = arrayfun(@(cn) isa(var, cn{1}), classnames);
        if any(matches)
            ii = find(matches);
            for j = 1:numel(ii)
                vars{ii(j)}{end+1} = vars0{i};
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