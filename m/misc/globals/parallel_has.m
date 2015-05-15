%> @ingroup globals parallelgroup
%> @file
%> @brief Checks if it is possible to use MATLAB's Parallel Computing Toolbox
%> @return \em flag Whether has or not
function flag = parallel_has()
parallel_assert();
global PARALLEL;
flag = PARALLEL.flag_has;
