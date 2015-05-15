%>@ingroup misc
%> @file
%> @brief Extracts file name from figure handle and calls @c help2()
function call_help(hFigure)
[~, prefix, ~, ~] = fileparts(get(hFigure, 'FileName'));
help2(prefix);
