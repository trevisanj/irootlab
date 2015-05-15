%>@ingroup idata globals
%> @file
%> @brief Returns the default postpr_test
%> @sa more_assert.m, setup_write.m
%
%> @param out If passed, returns it; otherwise, returns a default object
function out = def_postpr_test(out)
if nargin == 0 || isempty(out)
    more_assert();
    global MORE; %#ok<TLEV>
    irverbose(sprintf('INFO: Default postpr_test... (per-group aggregation: %s)', iif(MORE.flag_postpr_grag, 'yes', 'no')), 2);
    
    if MORE.flag_postpr_grag
        out = grag_mean();
    else
        out = [];
    end;
end;
