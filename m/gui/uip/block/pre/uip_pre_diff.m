%>@file
%>@ingroup guigroup
%>@brief Properties Window for @ref pre_diff
%>
%>@image html Screenshot-Differentiation.png
%>
%> <b>Differentiation order</b> - see pre_diff::order
%>
%> @sa pre_diff

%>@cond
function result = uip_pre_diff(o, data)
result.flag_ok = 0;
s = int2str(o.order);
while 1
    p = inputdlg('Enter differentiation order', 'Differentiation', 1, {s});
    if ~isempty(p)
        flag_error = 0;
        try
            order = int2str(eval(p{1}));
        catch me
            irerrordlg(me.message, 'Error');
            flag_error = 1;
        end;
        
        if ~flag_error
            result.params = {'order', order};
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
%>@endcond
