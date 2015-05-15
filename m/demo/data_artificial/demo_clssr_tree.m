%>@brief Draws classification regions for the Tree classifier
%>@file
%>@ingroup demo
%>
%>@sa clssr_tree
%>
%>@verbatim
%> if fea2 <= 5.91276
%>     if fea1 <= 3.28594
%>         if fea1 <= 3.02076
%>             class 0 (18: 100%)
%>         else
%>             if fea1 <= 3.17833
%>                 class 1 (2: 100%)
%>             else
%>                 class 0 (2: 100%)
%>     else
%>         class 1 (61: 100%)
%> else
%>     class 0 (54: 98.1818%)
%>@endverbatim
%>
%> @image html demo_clssr_tree_result.png

dslila = load_data_userdata_nc2nf2;

% ofsgt = fsgt_fisher();
ofsgt = fsgt_infgain();

clssr = clssr_tree();
clssr.fsgt = ofsgt;
% clssr.pruningtype = 1;
clssr.pruningtype = 3;
clssr.chi2threshold = 3;
clssr.no_levels_max = 10;

clssr = clssr.boot();
clssr = clssr.train(dslila);

est = clssr.use(dslila);



pars.x_range = [1, 6];
pars.y_range = [3, 8];
pars.x_no = 200;
pars.y_no = 200;
pars.ds_train = dslila;
pars.ds_test = [];
pars.flag_last_point = 1;
pars.flag_link_points = 0;
pars.flag_regions = 1;

figure;
colors_markers;
clssr.draw_domain(pars);
disp(clssr.get_treedescription());
