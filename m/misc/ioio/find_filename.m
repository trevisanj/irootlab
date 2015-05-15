%>@ingroup ioio
%>@file
%>@brief Finds a name for a new file.
%>
%> File name is composed as
%>@code
%>name = [prefix sprintf('_%04d', i) suffix '.' extension];
%>@endcode
%>
%> @param prefix
%> @param suffix
%> @param extension
%> @param flag_return_ext =1. If 0, will return the file name only, leaving to the called the job to complete with the extension
function name = find_filename(prefix, suffix, extension, flag_return_ext)

if ~exist('suffix', 'var')
    suffix = '';
end;

if ~exist('extension', 'var')
    extension = 'txt';
end;

if nargin < 4 || isempty(flag_return_ext)
    flag_return_ext = 1;
end;


files = dir(['*.' extension]);
flag_ok = 0;
for i = 1:9999
    name = [prefix sprintf('_%04d', i) suffix '.' extension];
    
    flag_exists = 0;
    for j = 1:length(files)
        if strcmp(name, files(j).name)
            flag_exists = 1;
            break;
        end;
    end;
    
    if ~flag_exists
        flag_ok = 1;
        break;
    end;
end;

if ~flag_ok
    irerror('Could not find a file name, gave up!');
end;


if ~flag_return_ext
    [who, name, cares] = fileparts(name); %#ok<NASGU,ASGLU>
end;