%> @ingroup globals usercomm
%> @file
%> @brief Closes progress bar - actually just shows for last time!

%> @param idx Index
function progress2_close(prgrss)

progress2_show(prgrss);
%irverbose([prgrss.bars(ib).sid, '[', 'FINISHED+++++++++++++++++', ']', sprintf('      /       - %6.2f%% %s', ela, proje, perccalc*100, bar.title)], 3);
