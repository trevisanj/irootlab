%> @ingroup globals usercomm
%> @file
%> @brief Closes progress bar and below

%> @param idx Index
function progress_close(idx)
progress_assert();

global PROGRESS;
if numel(PROGRESS.bars) > idx
    irwarning('Unfinished behind');
end;

PROGRESS.bars(idx:end) = [];

progress_show();
