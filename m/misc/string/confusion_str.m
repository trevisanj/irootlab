%>@ingroup string
%>@file
%>@brief Transforms matrix into a string
%> @todo no longer managing rejected properly

%> @param CC confusion matrix (first column is "rejected")
%> @param rowlabels row labels
%> @param collabels=rowlabels column labels
%> @param flag_perc=(auto-detect)
function s = confusion_str(CC, rowlabels, collabels, flag_perc)

if ~exist('collabels', 'var') || isempty(collabels)
    collabels = rowlabels;
end;

if ~exist('flag_perc', 'var') || isempty(flag_perc)
    flag_perc = sum(CC(:)-floor(CC(:))) > 0;
end;

[nr, nc] = size(CC);
flag_rejected = any(CC(:, 1) > 0);

collabels = ['rejected', collabels];

sperc = '';

if flag_perc
    sperc = '%';
    CC = round(CC*10000)/100; % To make 2 decimal places only
end;

W = 7; % the "7" could be more accurately resolved
% wids = W*ones(1, nc);
for i = 1:nc
    wids(i) = max(length(collabels{i}), W);
end;

wid1 = 0;
for i = 1:nr
    wid1 = max(wid1, length(collabels{i}));
end;

spaces = char(32)*ones(1, max([wids, wid1]));


% % % % % % % % % % % % % % % % % % % % % % % col_width = (widcols+1)*no_classes+maxlen+1; % +1 for vert spaces; +1 for '\n'
% % % % % % % % % % % % % % % % % % % % % % % nr = no_classes+1;
% % % % % % % % % % % % % % % % % % % % % % s = [char(32)*ones(1, widcol1) ' '];
% % % % % % % % % % % % % % % % % % % % % % s_ = [spaces2 'reject'];
% % % % % % % % % % % % % % % % % % % % % % s = [s, s_(end-widcols+1:end)];

s = [32*ones(1, wid1), ' '];

for i = iif(flag_rejected, 1, 2):nc
    s_ = [spaces collabels{i}];
    s = [s ' ' s_(end-wids(i)+1:end)];
end;
s = [s char(10)];

for i = 1:nr
    s_ = [rowlabels{i} spaces];
    s =  [s s_(1:wid1)];
    for j = iif(flag_rejected, 1, 2):nc
        s_ = [spaces sprintf('%6.2f', CC(i, j)) sperc];
        s =  [s ' ' s_(end-wids(j)+1:end)];
    end;
    s = [s char(10)];
end;
