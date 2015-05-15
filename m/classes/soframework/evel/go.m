%> Creates instance of class and executes its go() method
%>
%> @param classname name of a class that has the "go()" method
%> @param flag_exit = 0. Whether to exit MATLAB once it is finished
%>
%>
function go(classname, flag_exit)

rehash('path');

if nargin < 2 || isempty(flag_exit)
    flag_exit = 0;
end;

verbose_assert();
verbose_reset();
global VERBOSE;
% VERBOSE.flag_file = 1;
VERBOSE.flag_file = 0; % I wasn't really using these files too much anymore
VERBOSE.minlevel = 1;


try
    t = tic();

    o = eval([classname, '();']);
    o.go();

    irverbose(['$$$$$ Total ellapsed time: ', num2str(toc(t))]);
catch ME
    if ~flag_exit
        rethrow(ME);
    else
        irverbose(['Caught execution error, check dbstack() in stdout. Message is: ', ME.message], 3);
    end;
end;


if flag_exit
    exit;
end;
