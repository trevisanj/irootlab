%>@ingroup idata globals
%> @file
%> @brief Returns the default SGS
%> @sa more_assert.m, setup_write.m
%
%> @param out If passed, returns it; otherwise, returns a default object
function out = def_sgs(out)
if nargin == 0 || isempty(out)
    irverbose('INFO: Default SGS: 10-fold cross-validation');
    out = sgs_crossval();
    out.no_reps = 10;
    out.flag_group = 1;
    out.randomseed = 0;
    out.flag_perclass = 0;
end;
