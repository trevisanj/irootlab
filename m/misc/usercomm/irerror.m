%>@ingroup usercomm
%>@file
%>@brief Verboses and throws an Exception
%>
%> Exceptions raised by this function represent bad usage, and not necessarily a bug
function irerror(s)
irverbose(['{ERROR}', s], 3);
% dbstack();
s = strrep(s, '\', '\\'); % I think that MATLAB uses s as first argument o a printf()-like function, which messes the message if it has backslashes!
throw(MException('IRootLab:bad', s));
