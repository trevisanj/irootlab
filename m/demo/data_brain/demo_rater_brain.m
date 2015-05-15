%> @brief Classification of Brain data using LDC classifier, leave-one-out cross-validation
%> @file
%> @ingroup demo

ds01 = load_data_ketan_brain_atr();

u = pre_norm_std();
pre_norm_std01 = u;

out = pre_norm_std01.use(ds01);
ds01_pca01_std01 = out;

dsx = ds01_pca01_std01;

u = clssr_d();
u.type = 'linear';
u.flag_use_priors = 0;
clssr_d01 = u;

u = sgs_crossval();
u.flag_group = 1;
u.flag_perclass = 0;
u.randomseed = 3333;
u.flag_loo = 1;
sgs_crossval01 = u;

u = cascade_gragdecider();
u.blocks{2}.decisionthreshold = 0;
cascade_gragdecider01 = u;

u = grag_classes_first();
grag_classes_first01 = u;

% Log filename: /home/j/Documents/phd/evel/m/analysis/current/ketan_brain/irr_macro_0003.m
u = rater();
u.clssr = clssr_d01;
u.sgs = sgs_crossval01;
u.ttlog = [];
u.postpr_est = cascade_gragdecider01;
u.postpr_test = grag_classes_first01;
rater01 = u;
out = rater01.use(dsx);
estlog_classxclass_rater01 = out;

out = estlog_classxclass_rater01.extract_confusion();
irconfusion_classxclass01 = out;

%%

% Visualization

u = vis_balls();
vis_balls01 = u;
figure;
vis_balls01.use(irconfusion_classxclass01);
maximize_window([], 1);
set(gca, 'position', [0.2316    0.1100    0.6734    0.6047]);