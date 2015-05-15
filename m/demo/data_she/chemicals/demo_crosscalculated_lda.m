%>@brief Cross-calculated LDA scores
%>@ingroup demo
%>@file
%>
%> @image html demo_as_crossc02.png
%> <center>Cross-calculated scores plot</center>
%>
%> @image html demo_as_crossc03.png
%> <center>In-sample-calculated scores plot</center>
%>
%> @image html demo_as_crossc01.png
%> <center>Loadings vectors (1st factor) for each block in the cross-calculation process</center>
%>
%> @sa as_crossc

dataset = load_data_she5trays();
o = blmisc_classlabels_hierarchy();
o = o.setbatch({'hierarchy', 1});
blmisc_classlabels_hierarchy01 = o;
[blmisc_classlabels_hierarchy01, out] = blmisc_classlabels_hierarchy01.use(dataset);
dataset = out; % Dataset has only 5 classes now

o = pre_norm_std();
pre_norm_std01 = o;
[pre_norm_std01, out] = pre_norm_std01.use(dataset);
dataset_std01 = out; % Dataset variables are standardized


o = fcon_lda();
o = o.setbatch({'penalty', 0});
fcon_lda01 = o; % LDA block to perform the cross-calculation

o = sgs_crossval();
o.flag_group = 1;
o.flag_perclass = 0;
o.randomseed = 0;
o.flag_loo = 1;
sgs_crossval01 = o; % Leave-one-out cross-validation SGS

o = as_crossc();
o.mold = fcon_lda01;
o.sgs = sgs_crossval01;
as_crossc01 = o; % Cross-calculation block


%%

log = as_crossc01.use(dataset_std01); % Cross-calculation

%%

%%%
%%% Visualization of fold-wise loadings vectors
%%%
o = vis_crossloadings();
o = o.setbatch({'flag_abs', 0, ...
'flag_trace_minalt', 0, ...
'data_hint', [dataset], ...
'peakdetector', [], ...
'idx_fea', 1});
vis_crossloadings01 = o; % LD1

vis_crossloadings02 = vis_crossloadings01;
vis_crossloadings02.idx_fea = 2; % LD2

figure;
subplot(2, 1, 1);
vis_crossloadings01.use(log);
title('Loadings 1 (LD1)');
subplot(2, 1, 2);
vis_crossloadings02.use(log);
title('Loadings 2 (LD2)');
maximize_window();

%%%
%%% Visualization direct LDA and cross-calculated LDA scatter plots
%%%
out = log.extract_dataset();
irdata_crossc01 = out;

o = vis_scatter2d();
o = o.setbatch({'idx_fea', [1,2], ...
'confidences', [], ...
});
vis_scatter2d01 = o; % 2D scatterplot block

figure;
subplot(1, 2, 1);
vis_scatter2d01.use(irdata_crossc01);
title('Cross-calculated LDA scores');
xlabel('LD1'); ylabel('LD2');
v_xlim = xlim();
v_ylim = ylim();

fcon_lda01 = fcon_lda01.train(dataset_std01);
[fcon_lda01, out] = fcon_lda01.use(dataset_std01);
dataset_std01_lda01 = out;

subplot(1, 2, 2);
vis_scatter2d01.use(dataset_std01_lda01);
title('Direct LDA scores');
xlabel('LD1'); ylabel('LD2');
xlim(v_xlim);
ylim(v_ylim); % Same scale to show difference in the scattering of points
make_box();
maximize_window();
