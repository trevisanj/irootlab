%> @ingroup globals parallelgroup
%> @file
%> @brief Closes the "MATLAB pool"
function parallel_close()
parallel_assert();
global PARALLEL;
if PARALLEL.open_count > 0
    PARALLEL.open_count = PARALLEL.open_count-1;
end;
if PARALLEL.open_count <= 0
    if matlabpool('size') > 0
        matlabpool('close', 'force');
    end;
end;
