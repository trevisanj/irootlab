%> @brief Axis data setup for NFs axis
%>
%>
function o = raxisdata_nfs(nfs)
o = raxisdata();
o.label = 'Number of features';
o.values = nfs;
o.legends = arrayfun(@(x) sprintf('nf=%d', x), nfs, 'UniformOutput', 0);

