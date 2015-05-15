%>@brief Grid search to obtain best k-NN's k
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

u = sgs_crossval();
u.flag_group = 1;
u.flag_perclass = 0;
u.randomseed = 0;
u.flag_loo = 0;
u.no_reps = 10;
sgs_crossval01 = u;

u = gridsearch();
u.sgs = sgs_crossval01;
u.clssr = clssr_knn01;
u.chooser = [];
u.postpr_test = [];
u.postpr_est = decider();
u.log_mold = {};
u.no_refinements = 1;
u.maxmoves = 1;
u.paramspecs = {'k', 1:2:79, 0};
gridsearch01 = u;

%%

% Calculation

log_gridsearch01 = gridsearch01.use(ds01_stdhie01);

%%

% Visualization

out = log_gridsearch01.extract_sovaluess();
sovalues_gridsearch01 = out{1, 1};

u = vis_sovalues_drawplot();
u.dimspec = {[0 0], [1 2]};
u.valuesfieldname = 'rates';
u.ylimits = [];
u.xticks = [];
u.flag_star = 1;
u.xticklabels = {};
u.flag_hachure = 1;
vis_sovalues_drawplot01 = u;

figure;
vis_sovalues_drawplot01.use(sovalues_gridsearch01);
title(sovalues_gridsearch01.title);
legend off;
maximize_window([], 2.5);
save_as_png([], 'irr_knn_k');
