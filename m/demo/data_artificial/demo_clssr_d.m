%>@brief Draws classification regions for classifiers LDC/QDC
%>@file
%>@ingroup demo
%>
%>@sa clssr_d
%>

setup_load();


dslila = load_data_userdata_nc2nf2;

clssr = clssr_d();
clssr.flag_use_priors = 0;

% est = clssr.use(dslila);
% de = decider();
% est = de.use(est);

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

% Linear vs. ...
subplot(1, 2, 1);

clssr.type = 'linear';
clssr = clssr.boot();
clssr = clssr.train(dslila);

clssr.draw_domain(pars);
title('Linear case');


% ... Quadratic
subplot(1, 2, 2);

clssr.type = 'quadratic';
clssr = clssr.boot();
clssr = clssr.train(dslila);

clssr.draw_domain(pars);
title('Quadratic case');


maximize_window([], 2.2);
