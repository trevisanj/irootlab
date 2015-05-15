%>@brief Classification of Chemicals using LDC and cross-validation
%>@ingroup demos
%>@file
%>
%> Note that the averages in the scatterplots are the confusion matrix diagonal values.
%>
%>@image html demo_rater_result03.png
colors_markers();

ddemo = load_data_she5trays;
ddemo = data_select_hierarchy(ddemo, 1); % Selects B/C/E/F/G classes only

o = rater();
o.clssr = [];
o.postpr_est = [];
o.sgs = [];
o.ttlog = [];
rater01 = o;

log_raterout = rater01.use(ddemo); % The calculation

%%

% Creates report with all confusion matrices
o = report_estlog();
o = o.setbatch({'flag_individual', 1});
htmllog = o.use(log_raterout);

htmllog.open_in_browser();

% The next plots show the distributions of the classification rates along the diagonal of the confusion matrix
%
% ds_rows is an array of datasets. Each dataset contains the data from one row of the confusion matrix.
% The variables in the dataset are the columns of the confusion matrix. The rows in the dataset are the foldwise percentages
ds_rows = log_raterout.extract_datasets();

o = vis_scatter1d();
o = o.setbatch({'type_distr', 1, ...
'idx_fea', NaN});
visobj = o;

figure;
no_plots = numel(ds_rows);
for i = 1:no_plots
    subplot(1, no_plots, i);
    ds_row = ds_rows(i);
    visobj.idx_fea = i+1;
    visobj.use(ds_row);
    title(ds_row.title);
    legend off;
    p = get(gca, 'position');
    p(2) = 0.21; % y
    p(4) = 0.62; % height;
    set(gca, 'position', p);
end;
maximize_window([], no_plots);
