%> @ingroup globals assert
%> @file
%> @brief Initializes the MORE global, if not present.
%>
%> For reference on the MORE global, please view the source code for this file.
%>
%> @sa def_biocomparer.m, def_peakdetector.m, def_subsetsprocessor.m, def_postpr_est.m, def_postpr_test.m
function more_assert()
global MORE;
if isempty(MORE)
    % Default peakdetector options
    MORE.pd_maxpeaks = 6;
    MORE.pd_minaltitude = 0.105;
    MORE.pd_minheight = 0.10;
    MORE.pd_mindist_units = 31;
    
    % Default subsetsprocessor options
    MORE.ssp_stabilitythreshold = 0.05;
    MORE.ssp_minhits_perc = 0.031;
    MORE.ssp_nf4gradesmode = 'fixed';
    
    % Default biocomparer's half height
    MORE.bc_halfheight = 45;
    
    % Whether default post-processors are created with a group aggregation included
    MORE.flag_postpr_grag = 0;
end;
