%>@ingroup idata
%> @file
%> @brief Returns a cell of subsetsprocessors
%>
%> Please check the source code for exact definition.
%>
%> @sa subsetsprocessor
%
%> @param Returns a cell of subsetprocesso objects
function out = def_subsetsprocessors()
            
MINHITS_PERC = 0.031;

out = {};

% Four subsetsprocessor
ii = [1, 2, 3, 5];
for i = 1:numel(ii)
    ssp = subsetsprocessor();
    ssp.nf4grades = ii(i);
    ssp.nf4gradesmode = 'fixed';
    ssp.title = sprintf('%d informative feature%s', ii(i), iif(ii(i) == 1, '', 's'));
    out{end+1} = ssp;
end;

% A fifth
ssp = subsetsprocessor();
ssp.nf4grades = [];
ssp.nf4gradesmode = 'fixed';
ssp.title = 'All informative';
out{end+1} = ssp;

% A sixth
ssp = subsetsprocessor();
ssp.nf4grades = [];
ssp.nf4gradesmode = 'fixed';
ssp.minhits_perc = MINHITS_PERC;
ssp.title = sprintf('All informative with minimum hits of %.1f%%', MINHITS_PERC*100);
out{end+1} = ssp;
% 
% ssp = subsetsprocessor();
% ssp.nf4gradesmode = 'stability';
% ssp.stabilitythreshold = 0.05;
% ssp.weightmode = 'uniform';
% ssp.stabilitytype = 'kun';
% ssp.title = 'Stability threshold';
% out{end+1} = ssp;
