%>@ingroup idata globals
%> @file
%> @brief Returns the default postpr_est
%> @sa more_assert.m, setup_write.m
%
%> @param out If passed, returns it; otherwise, returns a default object
function out = def_postpr_est(out)
if nargin == 0 || isempty(out)
    more_assert();
    global MORE; %#ok<TLEV>
    irverbose(sprintf('INFO: Default postpr_est... (per-group aggregation: %s)', iif(MORE.flag_postpr_grag, 'yes', 'no')), 2);
    
    if MORE.flag_postpr_grag
        out = block_cascade();
        out.blocks = {grag_mean(), decider()};
    else
        out = decider();
    end;
end;
