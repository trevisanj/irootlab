%>@brief Draws classification regions for classifier eClass
%>@ingroup demo
%>@file
%>
%> @attention Needs the frbm (Fuzzy) classifier, which is not available in the standard distribution of IRootLab
%> Uses userdata_nc2nf2 dataset.
%>
%> Simple train-test (no cross-validation).
%>
%>@verbatim
%>          rejected       0       1
%> 0           0.00%  90.00%  10.00%
%> 1           0.00%   0.00% 100.00%
%>@endverbatim
%>
%>@sa frbm

colors_markers();


%Dataset load
ds01 = load_data_userdata_nc2nf2;

o = frbm();
o = o.setbatch({'scale', 1.6, ...
'epsilon', exp(-1), ...
'flag_consider_Pmin', 1, ...
'flag_perclass', 1, ...
'flag_clone_rule_radii', 1, ...
'flag_iospace', 1, ...
's_f_get_firing', 'frbm_firing_exp_default', ...
's_f_update_rules', 'frbm_update_rules_original', ...
'flag_rls_global', 0, ...
'rho', 0.5, ...
'ts_order', 0, ...
'flag_wta', 0, ...
'flag_class2mo', 1});


frbm01 = o;


o = pre_norm();
o = o.setbatch({'types', 's', ...
'idxs_fea', []});


pre_norm01 = o;


o = sgs_randsub();
o = o.setbatch({'flag_group', 0, ...
'flag_perclass', 1, ...
'randomseed', 112222, ...
'type', 'fixed', ...
'bites', [0.9 0.1], ...
'bites_fixed', [50, 10], ...
'no_reps', 1});

sgs_randsub01 = o;

[pre_norm01, out] = pre_norm01.use(ds01);

ds01_norm01 = out;

idxs = sgs_randsub01.get_obsidxs(ds01_norm01);

dstrain = ds01_norm01.map_rows(idxs{1, 1});
dstest = ds01_norm01.map_rows(idxs{1, 2});

frbm01 = frbm01.boot();
frbm01 = frbm01.train(dstrain);
est = frbm01.use(dstest);

de = decider();
est2 = de.use(est);

lo = estlog_classxclass();
lo.testlabels = dstest.classlabels;
lo.estlabels = est2.classlabels;
lo.flag_inc_t = 0;
pars2.ds_test = dstest;
pars2.est = est2;
lo = lo.allocate(1);
lo = lo.record(pars2);
cc = lo.get_confusion([], 1, []);
disp(confusion_str(cc.C, cc.rowlabels, cc.collabels));


%%

% Now the domain drawing

pars.x_range = [-2, 2];
pars.y_range = [-2, 2];
pars.x_no = 100;
pars.y_no = 100;
pars.ds_train = dstrain;
pars.ds_test = dstest;
pars.flag_last_point = 1;
pars.flag_link_points = 0;
pars.flag_regions = 1;

frbm01 = frbm01.boot();
frbm01 = frbm01.train(dstrain);

figure;
frbm01.draw_domain(pars);
title(frbm01.get_description());

%%

text(-0.53, -1.75, 1, 'Rule focal point', 'FontSize', 18);
text(0.475, -0.9, 1, 'Test point', 'FontSize', 18);
text(-0.23, -0.55, 1, 'Last point', 'FontSize', 18);

%%
maximize_window([], 1);
save_as_png([], 'irr_demo_eclass');