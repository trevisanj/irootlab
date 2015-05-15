%> @brief Adds directory to path with recursion into all subdirectories
%> @ingroup misc introspection
%> @file
function addtopath(directory)

dirs = getdirs(directory, {directory});

for i = 1:length(dirs)
    ss = dirs{i};
    disp(['Adding directory ' ss ' ...']);
    addpath(ss);
end;
