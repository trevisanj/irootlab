%>@ingroup usercomm
%>@file
%> @brief Verbose function. Currently just disp'ing the string
%
%> @param level
%>   @arg @c 0 - debug
%>   @arg @c 1 - "maybe important" info
%>   @arg @c 2 - important info
%>   @arg @c 3 - "must read" info
%> @sa @ref verbose_assert.m
function irverbose(s, level)
verbose_assert();
global VERBOSE;
if ~exist('level', 'var')
    level = 1;
end;

sp = '';
if ~isempty(VERBOSE.sid)
    sp = [':', VERBOSE.sid];
end;
% if matlabpool('size') > 0
%     sp = [':L', int2str(labindex)];
% end;

s = [sp, ':VB', int2str(level), ':', s];

if level >= VERBOSE.minlevel
    disp(s);
end;

if VERBOSE.flag_file
    if isempty(VERBOSE.filename)
        VERBOSE.filename = find_filename('irr_verbose', [], 'txt');
    end;

    try
        H = fopen(VERBOSE.filename, 'a+');
        if H == -1
            fprintf('Could not open file %s\n', VERBOSE.filename);
        else
            fwrite(H, [s, 10]);
        end;
        fclose(H);
    catch ME
        % Won't let program execution finish because of that! Sometimes I happen do delete the log file while cleaning directories, wouldn't want it
        % to stop just because of that.
        fprintf('___ IRVERBOSE FAILED WRITING TO FILE "%s": %s\n', VERBOSE.filename, ME.message);
    end;
end;

% if level == 3
%     msgbox(s);
% end;
