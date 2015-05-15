%> @ingroup globals usercomm assert
%> @file
%> @brief Initializes the @c VERBOSE global, if not present.
%>
%> For reference on the VERBOSE global, please check the source code for this file.
function verbose_assert()
global VERBOSE;
if isempty(VERBOSE)
    % Minimum level for output
    VERBOSE.minlevel = 0;
    % Whether to output to file besides screen
    VERBOSE.flag_file = 0; 
    % Output filename
    VERBOSE.filename = '';
    % Verbose session id
    VERBOSE.sid = '';
end;
