%> @file
%>@ingroup misc ioio
%>@brief Opens all @c .fig files in directory in GUIDE
d = dir('*.fig')
for i = 1:length(d)
    guide(d(i).name);
end;
