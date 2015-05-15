%>@ingroup idata
%> @file
%> @brief Returns the default FSG to be used in a testtable
%>
%> The default FSG is a t-test that returns p-values (flag_logtake is set to false)
%> @sa more_assert.m, setup_write.m
%
%> @param out If passed, returns it; otherwise, returns a default object
function out = def_fsg_testtable(out)
if nargin == 0 || isempty(out)
    out = fsg_test_t();
    out.flag_logtake = 0;
	irverbose('INFO: Default FSG for test table... (t-test)', 2);
end;