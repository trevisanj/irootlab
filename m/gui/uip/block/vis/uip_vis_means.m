%> @ingroup guigroup
%> @file
%> @brief Properties Windows for @ref vis_means
%>
%> Redirects to ask_peakdetector.m
%>
%> @sa ask_peakdetector.m, vis_means.m
%
%> @cond
function result = uip_vis_means(varargin)
result = ask_peakdetector(varargin{:});
%>@endcond
