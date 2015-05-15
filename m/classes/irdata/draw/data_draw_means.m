%>@ingroup datasettools
%>@file
%>@brief Draws class means

%> @param data Dataset
%> @param peakdetector (optional) @ref peakdetector object. If passed, will used it to draw peaks.
%> @param flag_pieces=1 Whether to use plot_curve_pieces() or normal plot
%>
%> @sa irdata, peakdetector
function data = data_draw_means(data, peakdetector, flag_pieces)

flag_pd = nargin >= 2 && ~isempty(peakdetector);

cm = classes2colormap(data.classes, 1);

ucl = unique(data.classes);

hs = [];

ymin = Inf;
ymax = -Inf;
for i = 1:numel(ucl)
    ytemp = mean(data.X(data.classes == ucl(i), :), 1);
    ymin = min([ymin, ytemp]);
    ymax = max([ymax, ytemp]);
    aa = {data.fea_x, ytemp, 'Color', cm(i, :), 'LineWidth', scaled(3)};
    if flag_pieces
        htemp = plot_curve_pieces(aa{:});
        hs(end+1) = htemp{1};
    else
        hs(end+1) = plot(aa{:});
    end;

    hold on;
    
    if flag_pd
        peakd = peakdetector.boot(data.fea_x, ytemp);
        idxs_peaks = peakd.use([], ytemp);
        draw_peaks(data.fea_x, ytemp, idxs_peaks);
    end;
    
end;
hl = legend(hs, data_get_legend(data));

ylabel([data.yname, iif(~isempty(data.yunit), sprintf(' (%s)', data.yunit), '')]);
format_xaxis(data);
format_ylim([ymin, ymax]);
format_frank([], [], hl);
