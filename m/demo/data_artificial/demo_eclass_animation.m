%>@brief Shows evolution of classifier eClass, saves animated GIF.
%>@ingroup demo
%>@file
%>
%> Uses userdata_nc2nf2 dataset.
%>
%> @image html video_evolving_0005.gif
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
'randomseed', 0, ...
'type', 'normal', ...
'bites', [0.5 0.1], ...
'bites_fixed', [5, 1]});

sgs_randsub01 = o;

[pre_norm01, out] = pre_norm01.use(ds01);

ds01_norm01 = out;

idxs = sgs_randsub01.get_obsidxs(ds01_norm01);

blshuffle = blmisc_rows_shuffle();

dstrain = blshuffle.use(ds01_norm01.map_rows(idxs{1, 1}));
dstest = ds01_norm01.map_rows(idxs{1, 2});

pars = struct();
pars.x_range = [-2.5, 2.5];
pars.y_range = [-2.5, 2.5];
pars.x_no = 30;
pars.y_no = 30;
pars.ds_train = dstrain;
% pars.ds_test = dstest;
pars.flag_last_point = 1;
pars.flag_link_points = 0;
pars.filename = find_filename('irr_video_evolving', '', 'gif');
pars.flag_regions = 1;

frbm01 = frbm01.boot();

frbm_save_movie(frbm01, pars);
