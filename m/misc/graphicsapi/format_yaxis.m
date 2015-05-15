%>@ingroup graphicsapi
%>@file
%>@brief Actually, only formats the y-label
%
%> @param par Object or structure with "yname" and "yunit" properties
function format_yaxis(par)

if isobject(par) || isstruct(par)
    ff = fields(par);

    if ismember('yname', ff)
        s = par.yname;
        if ismember('yunit', ff)
            if ~isempty(par.yunit);
                s = [s ' (' par.yunit ')'];
            end;
        end;
        ylabel(s);
    end;
end;
