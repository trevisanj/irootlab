%>@ingroup string conversion
%>@file
%>@brief Extracts things like 'A' from things like 'code = "A"'

function c = strip_code(params)
quote_indexes = regexp(params, '"');
if size(quote_indexes) < 2
    c = '';
else
    c = params(quote_indexes(1)+1:quote_indexes(2)-1); % extracts code from param string
end

