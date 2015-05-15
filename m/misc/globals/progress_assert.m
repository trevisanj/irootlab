%> @ingroup globals usercomm assert
%> @file
%> @brief PROGRESS globals management
function progress_assert()
global PROGRESS;
if isempty(PROGRESS)
    PROGRESS.bars = struct('title', {}, 'perc', {}, 'i', {}, 'n', {}, 'tic', {});
end;
