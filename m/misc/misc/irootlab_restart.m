%> @file
%> @ingroup misc usercomm introspection

%> @brief Changes to irootlab root directory and runs startup again
function irootlab_restart()

irst_p = pwd();
irst_d = get_rootdir();

irst_pa = regexp(path(), ':', 'split');

% Changes to IRoot root directory
cd(irst_d);

% Removes all current irootlab directories from MATLAB path
for i = 1:numel(irst_pa)
    if any(strfind(irst_pa{i}, irst_d))
        rmpath(irst_pa{i});
    end;
end;

% Runs startup
startup();

% Goes back to initial directory
cd(irst_p);

