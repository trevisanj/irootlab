%>@ingroup misc
%> @file
%> @brief Populates listbox/popupmenu with variables in workspace that belong to certain class
%>
%> Note: "leave blank" option should be used with popup menus only.

%> @param classname
%> @param h_list Handle to listbox or popupmenu
%> @param flag_blank=0 Whether to include a "(leave blank)" option
%> @param string_empty (optional) String to show instead of the default <b>(leave blank)</b> or <b>(none)</b> entries.
%>                     May also be a cell of strings. In this case, all options in the cell will be added at the beginning.
%> @param input (optional) (may be either a string with a class name or an instance of such class) 
%>        Input class to match. This is applicable only if @c classname is "block" or descendant.
function listbox_load_from_workspace(classname, h_list, flag_blank, string_empty, input)

if ~exist('input', 'var') 
    input = [];
end;

idxs = get(h_list, 'Value');

vars = get_varnames(classname, input);

if ~exist('flag_blank', 'var') 
    flag_blank = 0;
end;

if ~exist('string_empty', 'var')
    if flag_blank
        string_empty = 'leave blank';
    else
        string_empty = 'none';
    end;
end;


if isempty(vars)
    vars = make_cell(string_empty);
elseif flag_blank
    vars = [make_cell(string_empty), vars];
end;

if ~isempty(find(idxs > length(vars)))
    set(h_list, 'Value', 1); %> Prevents from selection falling beyond listbox items (MATLAB does not do it automatically)
end;
set(h_list, 'String', vars);


%-------
function c = make_cell(s)
if iscell(s)
    c = cellfun(@(x) iif(x(1) ~= '(', ['(', x, ')'], x), s, 'UniformOutput', 0);
else
    if s(1) ~= '('
        s = ['(', s, ')'];
    end;
    c = {s};
end;