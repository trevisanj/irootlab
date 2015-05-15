%>@ingroup misc
%>@file
%>@brief Fills editbox with description of object selected in listbox

%> @param h_list handle for listbox
%> @param h_edit handle for editbox
function show_description(h_list, h_edit)
ss = {'(No object)'};

varnames = listbox_get_selected_names(h_list);
if ~isempty(varnames)    
    if length(varnames) > 1
        ss = {'(Multiple objects)'};
    elseif length(varnames) == 1
        varname = varnames{1};
        var = evalin('base', varname);
        ss = {var.get_report()};
    end;
end;
set(h_edit, 'String', ss);
