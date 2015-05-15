%>@ingroup ioio
%>@file
%> @brief Attempts to detect type of single-spectrum files
%>
%> Possible outcomes are 'pir', 'opus', 'wire', or []
%> @sa mergetool.m

%> @param wild
%> @return String. Possible outcomes are [], 'pir', 'opus', 'wire'
function s = detect_spectrum_type(wild)
s = [];
% Extracts first file name
trimdot = 0;
flag_image = 0;
[filenames, groupcodes] = resolve_dir(wild, trimdot, flag_image); %#ok<NASGU>

if isempty(filenames)
    irerror('No files in directory');
end;

wild_new = fullfile(fileparts(wild), filenames{1});

totry = {'pir', 'opus', 'wire'};

for it = 1:numel(totry)
    flag_ok = 0;
    try
        flag_error = 0;
        s_code = sprintf('[mint, flag_error] = %s2data(''%s'', 0, 0, 0);', totry{it}, wild_new);
        eval(s_code);
        flag_ok = ~flag_error;
    catch ME
        irverbose('detect_spectrum_type() caught error:');
        irverbose(ME.getReport());
    end;
    
    if flag_ok
        irverbose(sprintf('<<< YES %s !!! >>>', totry{it}), 1);
        break;
    else
        % Not this one
        irverbose(sprintf('<<< Not %s ... >>>', totry{it}), 1);
    end;
end;
if flag_ok
    s = totry{it};
end;
