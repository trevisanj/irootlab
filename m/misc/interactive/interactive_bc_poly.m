%>@brief Plots polynomial baselines, Helps find order for polynomial-fit baseline correction
%>@ingroup interactive demo
%>@file
%> @sa pre_bc_poly
disp('*** Helps find polynomial order for polynomial-fit baseline correction ***');
varname = input('Enter dataset variable name [Demo Raman dataset]: ', 's');

if isempty(varname)
    dataset = load_data_raman_sample();
else
    dataset = eval([varname ';']);
end;
no = size(dataset.X, 1);


idx = input(sprintf('Enter index of spectrum to use (between 1 and %d) [1]: ', no));
if isempty(idx) || idx <= 0
    idx = 1;
end;

dataset = dataset.map_rows(idx);


order = 5;
epsilon = 0;

k = 1;
while 1
    order_ = input(sprintf('Enter polynomial order [%d]: ', order));
    if ~isempty(order_)
        order = order_;
    end;

%     epsilon_ = input(sprintf('Enter epsilon [%g]: ', epsilon));
%     if ~isempty(epsilon_)
%         epsilon = epsilon_;
%     end;
    pr = pre_bc_poly();
    pr.order = order;
    pr.epsilon = epsilon;

    dataset2 = pr.use(dataset);
    
    figure;
    k = k+1;
    hold off;
    plot(dataset.fea_x, dataset.X, 'r', 'LineWidth', 2);
    hold on;
    plot(dataset.fea_x, dataset2.X, 'b', 'LineWidth', 2);
    plot(dataset.fea_x, dataset.X-dataset2.X, 'k', 'LineWidth', 2);
    legend({'Before', 'After', 'Baseline'});
    format_xaxis(dataset);
    format_frank();
    title(sprintf('Order = %d', order));
    
%     s_happy = input(sprintf('Are you happy with order = %d and epsilon = %g [y/N]? ', order, epsilon), 's');
    s_happy = input(sprintf('Are you happy with order = %d [y/N]? ', order), 's');
    if ~isempty(intersect({s_happy}, {'y', 'Y'}))
        break;
    end;
end;


