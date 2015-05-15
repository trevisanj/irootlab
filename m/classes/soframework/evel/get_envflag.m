%> Reads environment variable and treats it as a boolean variable
%>
%> If the variable exists and it str2double() conversion is > 0, returns true
function flag = get_envflag(s)
sflag = getenv(s);
flag = ~isempty(sflag) && str2double(sflag) > 0;

