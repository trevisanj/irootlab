%>@ingroup ioio
%>@file
%>@brief Wraps over mYm to retry at lost connection errors
function r = irquery(varargin)
num_tries = 5;
i = 0;
flag_exit = 0;
while 1
    try
        r = mym(varargin{:});
        flag_exit = 1;
    catch ME
        irverbose(sprintf('Failed query (attempt %d/%d): ``%s``', i+1, num_tries, ME.message), 3);
        if i >= num_tries-1
            irverbose(sprintf('irquery() gave up after %d tries', i+1), 3);
            rethrow(ME);
        end;
        % Recovers from lost connection
        if any(strfind(ME.message, 'gone away')) || any(strfind(ME.message, 'ost connection')) || any(strfind(ME.message, 'ot connected'))
            assert_connected_to_cells();
        end;
    end;
    i = i+1;
    if flag_exit
        break;
    end;
end;