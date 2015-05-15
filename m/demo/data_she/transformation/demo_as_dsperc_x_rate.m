%>@brief (dataset %) x (classification rate %) curve to check sample size
%>@ingroup demo
%>@file
%>
%> Allows to verify whether the classification rate would tend to improve if there were more data; or whether apparently there is more data than needed.
%>
%> @sa as_dsperc_x_rate
fig_assert();

ddemo = load_data_she5trays;
ddemo = data_select_hierarchy(ddemo, 2);

% Applied some feature reduction to eliminate the problem with singular pooled covariance matrix in classify()
o = fcon_pca();
o = o.setbatch({'no_factors', 20, ...
'flag_rotate_factors', 0});
fcon_pca01 = o;
fcon_pca01 = fcon_pca01.train(ddemo);
ddemo = fcon_pca01.use(ddemo);



% Classifiers to be used

o = clssr_d();
o = o.setbatch({'type', 'linear'});
o.title = 'LDC';
clssr_d01 = o;

o = clssr_d();
o = o.setbatch({'type', 'quadratic'});
o.title = 'QDC';
clssr_d02 = o;%o;

clssr_d03 = clssr_svm();%o;
clssr_d03.title = 'SVM';


o = estlog_classxclass();
o.title = 'accuracy';
o.estlabels = ddemo.classlabels;
o.testlabels = ddemo.classlabels;
estlog_classxclass01 = o;

o = sgs_randsub();
o = o.setbatch({'flag_group', 0, ...
'flag_perclass', 1, ...
'randomseed', 0, ...
'type', 'simple', ...
'bites', [0.9 0.1], ...
'bites_fixed', [90 10], ...
'no_reps', 50});
sgs01 = o;

o = decider();
o = o.setbatch({'decisionthreshold', 0});
decider01 = o;

o = reptt_blockcube();
o = o.setbatch({'postpr_test', [], ...
'postpr_est', decider01, ...
'log_mold', {estlog_classxclass01}, ...
'block_mold', {clssr_d01, clssr_d02, clssr_d03}, ...
'sgs', sgs01});
cube = o;



o = as_dsperc_x_rate();
o.evaluator = cube;
o.percs_train = .1:.05:.90;
o.perc_test = .1;
lc = o;

%%

lo = lc.use(ddemo);

%%

o = vis_log_celldata();
o.idx = [1, 2];
figure;
o.use(lo);
title(sprintf('Number of spectra in dataset: %d', ddemo.no));
maximize_window([], 1.618);
save_as_png([], 'irr_dsperc_x_rate');
