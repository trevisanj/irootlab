%> @ingroup globals parallelgroup
%> @file
%> @brief Builds the PARALLEL global
%>
function parallel_reset()
global PARALLEL;

if matlabpool('size') > 0
    matlabpool('close', 'force');
end;

PARALLEL.flag_has = license('test' , 'distrib_computing_toolbox');
PARALLEL.open_count = 0;
