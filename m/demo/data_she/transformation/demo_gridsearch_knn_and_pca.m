%>@brief Combined optimization of PCA number of factors & k-NN k
%>@ingroup demo
%>@file
%>

%Dataset load
ds01 = load_data_she5trays();
u = cascade_stdhie();
u.blocks{2}.hierarchy = 2;
cascade_stdhie01 = u;
cascade_stdhie01 = cascade_stdhie01.boot();
out = cascade_stdhie01.use(ds01);
ds01_stdhie01 = out;

%Creates classifier
clssr_knn01 = clssr_knn();
clssr_knn01.k = 1;

fcon_pca01 = fcon_pca();

clssr_pca_knn = block_cascade();
clssr_pca_knn.blocks = {fcon_pca01, clssr_knn01};

u = sgs_crossval();
u.flag_group = 1;
u.flag_perclass = 0;
u.randomseed = 0;
u.flag_loo = 0;
u.no_reps = 10;
sgs_crossval01 = u;

u = gridsearch();
u.sgs = sgs_crossval01;
u.clssr = clssr_pca_knn;
u.chooser = [];
u.postpr_test = [];
u.postpr_est = decider();
u.log_mold = {};
u.no_refinements = 1;
u.maxmoves = 1;
u.paramspecs = {'blocks{1}.no_factors', 1:5:201, 0; 'blocks{2}.k', 1:5:106, 0};
gridsearch01 = u;

%%

% Calculation

log_gridsearch01 = gridsearch01.use(ds01_stdhie01);

%%

% Visualization

u = vis_sovalues_drawimage();
u.dimspec = {[0 0], [1 2]};
u.valuesfieldname = 'rates';
u.clim = [];
u.flag_logtake = 0;
vis_sovalues_drawimage01 = u;

out = log_gridsearch01.extract_sovaluess();

figure;
vis_sovalues_drawimage01.use(out{1});
title(out{1}.title);
maximize_window([]);
save_as_png([], 'irr_knn_and_pca');
