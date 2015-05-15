%> @ingroup globals parallelgroup
%> @file
%> @brief Opens a "MATLAB pool"
function parallel_open(no_labs)
parallel_assert();
global PARALLEL;
if matlabpool('size') == 0
    try
        if nargin < 1
            matlabpool('open')
        else
            matlabpool('open', no_labs);
        end;
    catch ME
        irverbose('Couldn''t start matlabpool');
    end;
end;
PARALLEL.open_count = PARALLEL.open_count+1;

