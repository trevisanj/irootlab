%>@file
%>@brief Returns True if MATLAB version is greater than 2014a
%> @ingroup misc
function b = is_2014()
b = strcmpc(version('-release'), '2014a') >= 0;
