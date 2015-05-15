%> @brief PCA-LDA demo, scores plots, cluster vectors
%> @ingroup demo
%> @file

ds01 = load_data_she5trays();

o = blmisc_classlabels_hierarchy();
o = o.setbatch({'hierarchy', 1});
blmisc_classlabels_hierarchy02 = o;

[blmisc_classlabels_hierarchy02, out] = blmisc_classlabels_hierarchy02.use(ds01);
ds01_hierarchy01 = out;



o = peakdetector();
o = o.setbatch({'flag_perc', 1, ...
'flag_abs', 1, ...
'minaltitude', 0, ...
'minheight', 0, ...
'mindist', 2, ...
'no_max', 3});

peakdetector01 = o;

o = cascade_pcalda();
o.blocks{1}.no_factors = 10;
o = o.boot();
cascade_pcalda01 = o;

cascade_pcalda01 = cascade_pcalda01.train(ds01_hierarchy01);

[cascade_pcalda01, out] = cascade_pcalda01.use(ds01_hierarchy01);

ds01_hierarchy01_pcalda01 = out;




%--------- Scores plots
o = vis_scatter2d();
o = o.setbatch({'idx_fea', [1,2,3], ...
'confidences', 0.9, ...
});

vis_scatter2d01 = o;

figure;
vis_scatter2d01.use(ds01_hierarchy01_pcalda01);

maximize_window([]);
save_as_png([], 'irr_scoresplots');

%--------- Cluster vectors visualization


% Note that the third class (Class "E") is taken as a reference - this is arbitrary and just for demonstration
o = vis_cv();
o = o.setbatch({'flag_abs', 0, ...
'flag_trace_minalt', 0, ...
'flag_envelope', 0, ...
'data_hint', [], ...
'peakdetector', peakdetector01, ...
'flag_bmtable', 0, ...
'data_input', ds01_hierarchy01, ...
'idx_class_origin', 3});
ovi = o;


% Cluster vectors as curves
figure;
ovi.use(cascade_pcalda01);
title('Cluster Vectors as curves');
maximize_window([]);
save_as_png([], 'irr_clustervectors');

% Cluster Vectors as "Peak Location Plots"
ovi.flag_bmtable = 1;
figure;
ovi.use(cascade_pcalda01);
title('Cluster Vectors as "Peak Location Plots"');
maximize_window([]);
save_as_png([], 'irr_clustervectors_plplots');