%>@ingroup graphicsapi
%> @file
%> @brief Draws stacked histograms
%>
%> Uses BAR(..., 'stacked') to do the job
%
%> @param x [nf] x-axis values.
%> @param histss [no_hists][nf] hits matrix
%> @param no_informative Number of histograms that are considered "informative"
%> @param colors See @ref colors2map.m 
%> @param x_hint =[]. [nf] x-axis values. If not passed or empty, uses @a x if @a hint is passed.
%> @param hint [nf] "hint" curve that helps the reading of the loadings. If not passed or empty, no hint curve is drawn.
%> @param peakd =[] Peak Detector object.
%> @param flag_trace_minalt =~isempty(peakd) Whether to draw the threshold line. Only works if the peak detector is passed.
%> @param flag_draw_peaks =~isempty(peakd) Whether to mark the detected peaks in the figure.
%> @param flag_print_peaks =~isempty(peakd) Whether to print detected peaks on the command line window.
%> @param flag_text =0 Whether to write peak wavenumbers besize the "x"'s
function draw_stacked(x, histss, no_informative, colors, x_hint, hint, peakd, flag_trace_minalt, flag_draw_peaks, flag_print_peaks, flag_text)
fig_assert();
if ~exist('x_hint', 'var') || isempty(x_hint)
    x_hint = x;
end;
if ~exist('hint', 'var') || isempty(hint)
    hint = [];
end;
if ~exist('colors', 'var') || isempty(colors)
%     colors = {[.8, 0, 0], [.9, .2, .2], .7*[1, 1, 1], .85*[1, 1, 1]};
    colors = {[], .85*[1, 1, 1]};
end;
% checks colors a bit
no_colors = numel(colors);
if no_colors == 3 && ~isempty(colors{1})
    irerror('If the number of colors passed is 3, the first element must be empty!');
end;

if ~exist('no_informative', 'var') || isempty(no_informative)
    no_informative = Inf;
end;
if ~exist('peakd', 'var') || isempty(peakd)
    peakd = [];
end;
if ~exist('flag_trace_minalt', 'var') || isempty(flag_trace_minalt)
    flag_trace_minalt = ~isempty(peakd);
end;
if ~exist('flag_draw_peaks', 'var') || isempty(flag_draw_peaks)
    flag_draw_peaks = ~isempty(peakd);
end;
if ~exist('flag_print_peaks', 'var') || isempty(flag_print_peaks)
    flag_print_peaks = ~isempty(peakd);
end;

if ~exist('flag_text', 'var') || isempty(flag_text)
    flag_text = 0;
end;

no_hists = size(histss, 1);
no_informative = min(no_informative, no_hists);

[cm, leg_cm, leg_la] = colors2map(colors, no_hists, no_informative);


%==============
% Hint curve
ymax = max(sum(histss, 1));

if ~isempty(hint)
    draw_hint_curve(x_hint, hint/max(hint)*ymax);
end;


%==============
% Main drawing
bar(x, histss', 'stacked', 'LineStyle', 'none');
hold on;
colormap(gca(), cm);

% Legends
nl = numel(leg_la);
for i = 1:nl
    h(i) = plot_marker(leg_cm(i, :), 15);
end;
legend(h, leg_la);


%==============
% The peaks
flag_bother_peaks = ~isempty(peakd) && (flag_print_peaks || flag_draw_peaks);
if flag_bother_peaks
    y = sum(histss(1:no_informative, :), 1);
    peakd = peakd.boot(x, y);
    idxs_peaks = peakd.use([], y);

    if flag_draw_peaks
        draw_peaks(x, y, idxs_peaks, flag_text);
    end;

    if flag_print_peaks
        fprintf('---------------- Peaks %s -----------------\n', '');
        print_peaks(x, idxs_peaks);
    end;

    % Plots "minimum altitude" line
    if flag_trace_minalt
        C = [.3, .3, .3];
        draw_threshold_line(x, peakd.minalt, [], C);
    end;
end;


% Formatting
format_frank();
format_xaxis(x);
ylabel('Hits');


set(gca, 'Ylim', [0, ceil(ymax*1.025)]);




%===========================================================================================================================================
function h = plot_marker(color, markersize)
h = plot(-1000, 0, 'LineStyle', 'none', 'Marker', 's', 'MarkerSize', markersize, 'Color', color, 'MarkerFaceColor', color);
