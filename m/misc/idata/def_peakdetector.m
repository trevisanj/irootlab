%>@ingroup idata globals
%> @file
%> @brief Returns the default peakdetector
%> @sa more_assert.m, setup_write.m
%
%> @param out If passed, returns it; otherwise, returns a default object
function out = def_peakdetector(out)
if nargin == 0 || isempty(out)
    more_assert();
    global MORE; %#ok<TLEV>
    irverbose(sprintf('INFO: Default peakdetector... (%d peaks)', MORE.pd_maxpeaks), 2);
    out = peakdetector();
    out.mindist_units = MORE.pd_mindist_units;
    out.minaltitude = MORE.pd_minaltitude;
    out.minheight = MORE.pd_minheight;
    out.no_max = MORE.pd_maxpeaks;
end;
