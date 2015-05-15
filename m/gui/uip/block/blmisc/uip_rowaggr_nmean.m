%> @ingroup guigroup
%> @file
%> @brief Properties Windows for @ref rowaggr_nmean
%>
%> Asks for new class labels
%>
%> @sa rowaggr_nmean
%
%> @cond
function result = uip_rowaggr_nmean(o, data)
result.flag_ok = 0;
% % % if ~isempty(data) && isa(data, 'irdata')
% % % end;
while 1
    flag_break = 0;
    p = inputdlg('Average every "n" data rows/spectra (enter "n" below):', 'Average every ...', 1, {'10'});
    if ~isempty(p)
        s = p{1};
        flag_error = 0;
        serror = '';
        try
            n = eval(s);
            if ~isnumeric(n)
                serror = sprintf('"%s" is not numeric!', s);
                flag_error = 1;
            end;
        catch ME
            serror = ME.message;
            flag_error = 1;
        end;
        
        if ~flag_error
            result.params = {'n', int2str(n)};
            result.flag_ok = 1;
            flag_break = 1;
        end;
        
        if flag_error
            irerrordlg(serror, 'Error');
        end;
    else
        flag_break = 1;
    end;
    
    if flag_break
        break;
    end;
end;
%> @endcond
