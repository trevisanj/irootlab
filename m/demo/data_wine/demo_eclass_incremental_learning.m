%> @brief Increase of classification rate as eClass is incrementally trained
%> @file
%> @ingroup demo
%>
%> This example shows how an incremental classifier can vary its performance depending on the order the training data is fed into the classifier.
%>
%> @image html demo_reptt_incr.png

ds01 = load_data_uci_wine();

% Random 90%-10% split
o = blmisc_split_proportion();
o.proportion = 0.9;
blmisc_split_proportion01 = o;
pieces = blmisc_split_proportion01.use(ds01);


% eClass0 Fuzzy classifier
o = frbm();
o = o.setbatch({'scale', 0.8, ...
'epsilon', exp(-1), ...
'flag_consider_Pmin', 1, ...
'flag_perclass', 1, ...
'flag_clone_rule_radii', 1, ...
'flag_iospace', 1, ...
's_f_get_firing', 'frbm_firing_exp_default', ...
's_f_update_rules', 'frbm_update_rules_kg1', ...
'flag_rls_global', 0, ...
'rho', 0.5, ...
'ts_order', 0, ...
'flag_wta', 0, ...
'flag_class2mo', 1});
frbm01 = o;
frbm01.flag_rtrecord = 1;
frbm01.record_every = 3;
frbm01.title = 'eClass0 1 rule per class';


% eClass1 fuzzy classifier
o = frbm();
o = o.setbatch({'scale', 0.8, ...
'epsilon', exp(-1), ...
'flag_consider_Pmin', 1, ...
'flag_perclass', 0, ...
'flag_clone_rule_radii', 1, ...
'flag_iospace', 1, ...
's_f_get_firing', 'frbm_firing_exp_default', ...
's_f_update_rules', 'frbm_update_rules_kg1', ...
'flag_rls_global', 0, ...
'rho', 0.5, ...
'ts_order', 1, ...
'flag_wta', 0, ...
'flag_class2mo', 1});
frbm02 = o;
frbm02.flag_rtrecord = 1;
frbm02.record_every = 3;
frbm02.title = 'eClass1 1 rule only';


% SGS that will give the dataset permutations of the 90% used for training
o = sgs_randsub();
o = o.setbatch({'flag_group', 0, ...
'flag_perclass', 0, ...
'randomseed', 4321, ...
'type', 'simple', ...
'bites', 1, ...
'no_reps', 10});
sgs01 = o;

o = estlog_classxclass();
o.estlabels = ds01.classlabels;
o.testlabels = ds01.classlabels;
estlog_classxclass01 = o;

o = decider();
o = o.setbatch({'decisionthreshold', 0});
decider01 = o;

oi = reptt_incr();
% oi.block_mold = {frbm01, frbm02};
oi.block_mold = {frbm02};
oi.log_mold = {estlog_classxclass01};
oi.postpr_est = decider01;
oi.sgs = sgs01;
oi.flag_parallel = 1;  % <------------------------Note that it will try to use the MATLAB Parallel Computing Toolbox

irdata_incr01 = oi.use(pieces);


%%

fig_assert();
global COLORS;
C1 = COLORS;
enlighten_colors(1.5);

o = vis_alldata();
vis_alldata01 = o;

figure;
vis_alldata01.use(irdata_incr01);
hold on;

COLORS = C1;
o = vis_means();
vis_means01 = o;

vis_means01.use(irdata_incr01);

ylim([min(irdata_incr01.X(:))*0.975, max(irdata_incr01.X(:))*1.025]);
make_box();
legend off;
title('Individual runs and average curve');
maximize_window([], [], .8);
save_as_png([], 'irr_eclass_incremental');
