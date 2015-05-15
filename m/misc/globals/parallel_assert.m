%> @ingroup globals parallelgroup assert
%> @file
%> @brief Initializes the PARALLEL global, if not present.
%> @sa parallel_reset.m

function parallel_assert()
global PARALLEL;
if isempty(PARALLEL)
    parallel_reset();
end;
