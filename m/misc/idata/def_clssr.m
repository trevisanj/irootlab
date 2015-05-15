%>@ingroup idata globals
%> @file
%> @brief Returns the default classifier
%> @sa more_assert.m, setup_write.m
%
%> @param out If passed, returns it; otherwise, returns a default object
function out = def_clssr(out)
if nargin == 0 || isempty(out)
    irverbose('INFO: Default classifier: LDC (linear classifier) with correction for unbalanced datasets');
    out = clssr_d();
    out.flag_use_priors = 0;
end;
