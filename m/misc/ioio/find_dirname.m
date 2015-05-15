%>@ingroup ioio
%>@file
%>@brief Finds a name for a new directory
%>
%
%> @param prefix For directory name as "prefix<nnnn>"
function name = find_dirname(prefix)

flag_ok = 0;
for i = 1:9999
    name = sprintf('%s%04d', prefix, i);
    
    flag_ok = ~exist(name, 'dir');
    if flag_ok
        break;
    end;
end;

if ~flag_ok
    irerror('Could not find a file name, gave up!');
end;
