%>@ingroup datasettools
%> @file
%> @brief Draws the 3D figure: per-feature Histograms
function data = data_draw_3dhist(data, cc)

X = data.X;
nf = size(X, 2);
min_data = min(min(X));
max_data = max(max(X));

hist_no_divisions = 100;
hist_space = linspace(min_data, max_data, hist_no_divisions);
mm = zeros(hist_no_divisions, nf);
for i = 1:nf
    mm(:, i) = hist(X(:, i), hist_space);
end;

% Scaling between 0 and 1
mm = mm/max(max(mm))*100;


% mm = [zeros(1, nf); mm; zeros(1, nf)];
% mm = [zeros(size(mm, 1), 1) mm zeros(size(mm, 1), 1)];


if ~exist('cc', 'var')
    cc = mm;
end;


[xx, yy] = meshgrid([data.fea_x], hist_space);

if length(cc) == 1
    cc = ones(size(xx, 1), size(xx, 2))*cc;
end;


surf(xx, yy, mm, cc);
format_xaxis(data);
set(gca, 'YLim', [min_data, max_data]);
zlabel('%');
shading('interp');
format_frank();

% data.hist_space = hist_space;
% data.mm = mm;
