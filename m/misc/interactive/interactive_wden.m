%>@brief Helps find thresholds for wavelet de-noising
%>@ingroup interactive
%>@file
%>
%> <h3>References</h3>
%> ﻿[1] M. Misiti, Y. Misiti, G. Oppenheim, and J.-M. Poggi, Wavelet Toolbox User’s Guide R2012b. Mathworks, 2012.

disp('*** Helps find thresholds for wavelet de-noising ***');
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


thresholds = [0, 0, 0, 1000, 1000, 1000];
no_levels = 6;

k = 1;
while 1
    no_levels_ = input(sprintf('Enter no_levels [%g]: ', no_levels));
    if ~isempty(no_levels_)
        no_levels = no_levels_;
    end;

    thresholds_ = input(sprintf('Enter thresholds [%s]: ', mat2str(thresholds)));
    if ~isempty(thresholds_)
        thresholds = thresholds_;
    end;


    dataset2 = dataset;
    dataset2.X = wden(dataset.X, no_levels, thresholds, 'haar');
    
    figure;
    k = k+1;
    hold off;
    plot(dataset.fea_x, dataset.X, 'r', 'LineWidth', 2);
    hold on;
    plot(dataset.fea_x, dataset2.X, 'b', 'LineWidth', 2);
    plot(dataset.fea_x, dataset.X-dataset2.X, 'k', 'LineWidth', 2);
    legend({'Before', 'After', 'Difference'});
    format_xaxis(dataset);
    format_frank();
    
%     s_happy = input(sprintf('Are you happy with thresholds = %d and no_levels = %g [y/N]? ', thresholds, no_levels), 's');
    s_happy = input(sprintf('Are you happy [y/N]? '), 's');
    if ~isempty(intersect({s_happy}, {'y', 'Y'}))
        break;
    end;
end;


