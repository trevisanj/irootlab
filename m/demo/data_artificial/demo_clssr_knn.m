%>@brief Draws classification regions for classifier k-NN
%>@file
%>@ingroup demo
%>
%>@sa clssr_knn
%>

dslila = load_data_userdata_nc2nf2;

clssr = clssr_knn();

pars.x_range = [1, 6];
pars.y_range = [3, 8];
pars.x_no = 200;
pars.y_no = 200;
pars.ds_train = dslila;
pars.ds_test = [];
pars.flag_last_point = 1;
pars.flag_link_points = 0;
pars.flag_regions = 1;

K = [1, 10, 30];
no_k = numel(K);
figure;
for i = 1:no_k
    subplot(1, no_k, i);
    clssr.k = K(i);
    clssr = clssr.boot();
    clssr = clssr.train(dslila);

    clssr.draw_domain(pars);
    title(sprintf('k = %d', K(i)));
    p = get(gca, 'position');
    p(2) = .2; p(4) = .65;
    set(gca, 'position', p);
end;
maximize_window([], no_k);

