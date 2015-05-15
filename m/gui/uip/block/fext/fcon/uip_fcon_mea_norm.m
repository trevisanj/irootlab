%>@file
%>@ingroup guigroup
%>@brief Properties Window for @ref fcon_mea_norm
%>
%>@image html Screenshot-Norm.png
%>
%> <b>Type of norm</b> - see MATLAB's @c norm() function, fcon_mea_norm::type
%>
%>
%> @sa fcon_mea_norm

%>@cond
function result = uip_fcon_mea_norm(o, data)
result.flag_ok = 0;
p = inputdlg('Type of norm (see MATLAB norm() function for options):', 'Norm', 1, {'2'});
if ~isempty(p)
    type = eval(p{1});
    if ischar(type)
        type = ['''' type ''''];
    else
        type = num2str(type);
    end;
    result.params = {'type', type};
    result.flag_ok = 1;
end;
%>@endcond
