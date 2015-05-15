%> @ingroup guigroup
%> @file
%> @brief Properties Windows for @ref blmisc_split_proportion
%>
%> Asks for a proportion (a number between 0 and 1) (see blmisc_split_proportion::proportion)
%>
%> @sa blmisc_split_proportion
%
%> @cond
function result = uip_blmisc_split_proportion(o, data)
result.flag_ok = 0;
while 1
    p = inputdlg('Enter proportion p (0 < p < 1)', 'Proportion', 1, {num2str(o.proportion)});
    if isempty(p)
        if ~iscell(p)
            irerror('Please specify!', 'Invalid output');
        else
            break;
        end;
    else
        result.params = {'proportion', num2str(eval(p{1}))};
        result.flag_ok = 1;
        break;
    end;
end;
%>@endcond
