%> @file
%> @ingroup codegen
%> @brief Generates code containing values of certain object properties
%>
%> Property names cna be specified with dots. In this case, properties will be
%> accessed within objects that are properties themselves.
%
%> @param obj Object
%> @param props Cell of property names with optional comments
%>     @arg Format 1: {'property name', 'comment; ...}
%>     @arg Format 2: {'property name', ...}
%> @param flag_alt=0 Alternative format to just paste on the properties section of code file
function s = code_props(obj, props, flag_alt)

if nargin < 3
    flag_alt = 0;
end;

n = length(props);
flag_comments = n ~= numel(props);

s_indent = iif(flag_alt, '        ', '');
s_comment = iif(flag_alt, '%>', '%');
s_o = iif(flag_alt, '', 'o.');

s = '';
for i = 1:n
    if flag_comments
        s = cat(2, s, s_indent, s_comment, ' ', props{i, 2}, 10);
    end;
    s_p = iif(flag_comments, props{i, 1}, props{i});
    ss = regexp(s_p, '\.', 'split');
    p = obj;
    for j = 1:numel(ss)
        p = p.(ss{j});
    end;
    s = cat(2, s, s_indent, s_o, s_p, ' = ', convert_to_str(p), ';', 10);
end;

