%> @ingroup globals usercomm parallelgroup
%> @file
%> @brief Sets VERBOSE.sid
function verbose_set_sid(s)
verbose_assert();
global VERBOSE;
VERBOSE.sid = s;

