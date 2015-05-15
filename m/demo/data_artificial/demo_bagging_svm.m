%>@brief Bagging example using SVM classifier and drawing classification regions.
%>@file
%>@ingroup demo
%>
%> Uses a 2D artificial data to show the classification boundaries of component classifiers and of the overall
%> classifier.
%>
%> @image html test_bagging_result01.png
%> <center>Figure 1 - classification domains of 6 component classifiers, each one trained on 5% of the data points
%> randomly picked.</center>
%>
%> @image html test_bagging_result02.png
%> <center>Figure 1 - classification domain of classifier resulting from bagging the 6 classifiers represented in Figure 1.</center>

fig_assert();

%Dataset load
ds01 = load_data_userdata_nc2nf2;

clssr_svm01 = clssr_svm();
clssr_svm01.c = 2;
clssr_svm01.gamma = 1.2;

o = sgs_randsub();
o.bites = .05;
o.type = 'balanced';
o.no_reps = 6;
o.randomseed = 323233;
o.flag_perclass = 1;
sgs03 = o;

esag01 = esag_linear1();

o = aggr_bag();
o.block_mold = clssr_svm01;
o.sgs = sgs03;
o.esag = esag01;
clssr = o;

clssr = clssr.boot();
clssr = clssr.train(ds01);

pars.x_range = [1, 6];
pars.y_range = [3, 8];
pars.x_no = 200;
pars.y_no = 200;
pars.ds_train = ds01;
pars.ds_test = [];
pars.flag_last_point = 1;
pars.flag_link_points = 0;
pars.flag_regions = 1;

figure;
colors_markers;


subdatasets = ds01.split_map(sgs03.get_obsidxs(ds01));
for i = 1:6
    subplot(2, 3, i);
    pars.ds_train = subdatasets(i);
    clssr.blocks(i).block.draw_domain(pars);
end;
maximize_window([]);
save_as_png([], 'irr_demo_bagging_svm_components');

figure;
pars.ds_train = ds01;
clssr.draw_domain(pars);
title('Aggregation of 6 SVM classifiers trained differently');
maximize_window([], 1);
save_as_png([], 'irr_demo_bagging_svm_aggr');
% disp(clssr.get_treedescription());
