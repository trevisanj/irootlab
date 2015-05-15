%>@ingroup conversion string
%>@file
%>@brief Converts a parameters cell into a string
%>
%> The parameters cell is like {'name1', value1, 'name2', value2, ...}
%> @todo find and group documentation about this parameters convention
%
%> @param params
%> @param flag_o =0. Whether to generate a string like "o.property1 = value1;\no.property2 = value2;\n ..."
%> @return A string
function s = params2str(params, flag_o)

if nargin < 2 || isempty(flag_o) || ~flag_o
    s = '{';
    for i = 1:length(params)/2
        if i > 1; s = [s ', ...' char(10)]; end;
        s = [s '''' params{i*2-1} ''', ' params{i*2}];
    end;
    s = [s '}'];
else
    s = '';
    for i = 1:length(params)/2
%         if i > 1; s = [s ', ...' char(10)]; end;
        s = cat(2, s, 'u.', params{i*2-1}, ' = ', params{i*2}, ';', 10);
    end;
end;
