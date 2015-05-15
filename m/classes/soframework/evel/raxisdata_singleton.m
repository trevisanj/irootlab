%> @brief Singleton raxisdata
%>
%>
function o = raxisdata_singleton(label)
o = raxisdata();
if nargin < 1 || isempty(label)
    o.label = 'Singleton';
else
    o.label = label;
end;
o.values = 1;
