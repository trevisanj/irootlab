%>@ingroup datasettools
%>@file
%>@brief Draws class means with hachured aread behind to give an idea of variability

%> @param data Dataset
function data_draw_hachures(data)
fig_assert();


ymin = Inf;
ymax = -Inf;
for i = 1:data.nc
    X = data.X(data.classes == i-1, :);
    curve = mean(X, 1);
    stds = std(X, 1);

    ymin = min([ymin, curve-stds]);
    ymax = max([ymax, curve+stds]);



    curve = mean(X, 1);
    stds = std(X, 1);

    draw_stdhachure(data.fea_x, curve, stds, find_color(i));
    hold on;

    hh(i) = plot(data.fea_x, curve, 'Color', find_color(i), 'LineWidth', scaled(3));
end;
            
if ~isempty(hh)
    legend(hh, data_get_legend(data));
end;

ylabel([data.yname, iif(~isempty(data.yunit), sprintf(' (%s)', data.yunit), '')]);
format_xaxis(data);
format_ylim([ymin, ymax]);
format_frank();
