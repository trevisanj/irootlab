%> @ingroup misc graphicsapi
%> @brief Closes windows
%> @file
%>
%> This function closes the figures (close all) and browsers, so far
function out = close_windows()
close all;
com.mathworks.mlservices.MatlabDesktopServices.getDesktop.closeGroup('Web Browser');
