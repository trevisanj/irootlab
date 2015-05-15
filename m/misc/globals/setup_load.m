%> @file
%> @ingroup globals setupgroup
%> @brief Executes file irootlab_setup.m, if exists.
function setup_load()
assert_all();

if exist('irootlab_setup.m', 'file')
    irootlab_setup;
elseif exist('irootsetup.m', 'file') % Backward compatibility
    irootsetup;
end;
