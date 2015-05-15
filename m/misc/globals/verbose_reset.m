%> @ingroup globals usercomm
%> @file
%> @brief Resets the output vebose filename
function verbose_reset()
verbose_assert();
global VERBOSE;
VERBOSE.filename = '';

