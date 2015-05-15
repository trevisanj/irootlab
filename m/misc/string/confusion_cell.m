%>@ingroup string
%>@file
%>@brief Transforms matrix into a cell of strings

%> @param CC confusion matrix (first column is "rejected")
%> @param flag_perc =(auto-detect)
function c = confusion_cell(CC, flag_perc)

if ~exist('flag_perc', 'var') || isempty(flag_perc)
    flag_perc = sum(CC(:)-floor(CC(:))) > 0;
end;

if flag_perc
    CC = round(CC*10000)/100; % To make 2 decimal places only
end;

c = num2cell(CC);

if flag_perc
    [n1, n2] = size(c);
    for j = 1:n1
        for k = 1:n2
            c{j, k} = sprintf('%g%%', c{j, k});
        end;
    end;
end;
