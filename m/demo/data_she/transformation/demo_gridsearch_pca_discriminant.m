%>@brief Grid search to simultaneously optimize (PCA number of factors) x ('linear'/'quadratic')
%>@ingroup demo
%>@file

ds01 = load_data_she5trays();

u = blmisc_classlabels_hierarchy();
u.hierarchy = 2;
blmisc_classlabels_hierarchy01 = u;
out = blmisc_classlabels_hierarchy01.use(ds01);
ds01_hierarchy01 = out;

%Rename irdata object
dsx = ds01_hierarchy01; clear ds01_hierarchy01;

u = pre_std();
pre_std01 = u;

u = fcon_pca();
u.no_factors = 10;
u.flag_rotate_factors = 0;
fcon_pca01 = u;

u = clssr_d();
u.type = 'linear';
u.flag_use_priors = 0;
clssr_d01 = u;

u = cascade_gragdecider();
u.blocks{2}.decisionthreshold = 0;
cascade_gragdecider01 = u;

u = grag_classes_first();
grag_classes_first01 = u;

u = block_cascade();
u.blocks = {pre_std01, fcon_pca01, pre_std01, clssr_d01, cascade_gragdecider01};
block_cascade01 = u;

%Rename block_cascade object
classifier = block_cascade01; clear block_cascade01;
u = sgs_crossval();
u.flag_group = 1;
u.flag_perclass = 1;
u.randomseed = 0;
u.flag_loo = 0;
u.no_reps = 10;
sgs_crossval01 = u;

u = gridsearch();
u.sgs = sgs_crossval01;
u.clssr = classifier;
u.chooser = [];
u.postpr_test = grag_classes_first01;
u.postpr_est = [];
u.log_mold = {};
u.no_refinements = 1;
u.paramspecs = {'blocks{2}.no_factors', 1:58, 0;
    'blocks{4}.type', {'linear', 'quadratic'}, 0};
u.maxmoves = 1;
gridsearch01 = u;

%%

% Calculation

out = gridsearch01.use(dsx);
log_gridsearch_gridsearch01 = out;

%%

% Visualization

out = log_gridsearch_gridsearch01.extract_sovaluess();
sovalues_gridsearch01 = out{1, 1};

% Visualizes classification rates as a heat map
u = vis_sovalues_drawimage();
u.dimspec = {[0 0], [1 2]};
u.valuesfieldname = 'rates';
u.clim = [];
u.flag_logtake = 0;
vis_sovalues_drawimage01 = u;
figure;
vis_sovalues_drawimage01.use(sovalues_gridsearch01);
title('Classification rate (%) - (PCA no-factors) x (classifier type)');
maximize_window([], 9);
save_as_png([], 'irr_gridsearch_pca_discriminant_image');

% The information is the same, but this visualization is as curves
u = vis_sovalues_drawplot();
u.dimspec = {[0 0], [1 2]};
u.valuesfieldname = 'rates';
u.flag_legend = 1;
u.flag_star = 1;
u.flag_hachure = 1;
u.ylimits = [];
u.xticks = [];
u.xticklabels = {};
vis_sovalues_drawplot01 = u;
figure;
vis_sovalues_drawplot01.use(sovalues_gridsearch01);
title('(PCA no-factors) x (Classification rate)');
maximize_window();
save_as_png([], 'irr_gridsearch_pca_discriminant_curves');

