%>@ingroup guigroup
%>@file
%>@brief Parameters Window for @ref decider
%>
%>@image html Screenshot-Decider.png
%>
%> <b>Minimum maximum posterior probability threshold<b> - a number between 0 and 1. See decider::decisionthreshold
%>
%> @sa decider

%>@cond
function result = uip_decider(o, data)
result.flag_ok = 0;
while 1
    p = inputdlg('Minimum maximum posterior probability threshold [0, 1]:', 'Decider', 1, {'0'});
    if ~isempty(p)
        decisionthreshold = eval(p{1});
        if decisionthreshold < 0 || decisionthreshold > 1
            irerrordlg('Between 0 and 1', 'Please try again, mate');
        else
            decisionthreshold = num2str(decisionthreshold);
            result.params = {'decisionthreshold', decisionthreshold};
            result.flag_ok = 1;
            break;
        end;
    else
        break;
    end;
end;
%>@endcond