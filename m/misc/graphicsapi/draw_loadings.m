%>@ingroup graphicsapi
%> @file
%> @brief Draws loadings curves with many options
%
%> @param x [nf] x-axis values.
%> @param L [nf][number_of_loadings] loadings matrix.
%> @param x_hint =[]. [nf] x-axis values. If not passed or empty, uses @a x if @a hint is passed.
%> @param hint [nf] "hint" curve that helps the reading of the loadings. If not passed or empty, no hint curve is drawn.
%> @param legends =[]  One legend per loadings curve. If not passed, no legend is drawn.
%> @param flag_abs =0 Whether to take the absolute value of the loadings matrix.
%> @param peakd =[] Peak Detector object.
%> @param flag_trace_minalt =0 Whether to draw the threshold line. Only works if @a threshold is passed.
%> @param flag_draw_peaks =0 Whether to mark the detected peaks in the figure.
%> @param flag_print_peaks =0 Whether to print detected peaks on the command line window.
%> @param flag_histogram =0 Whether to plot line or histogram.
%> @param flag_envelope =0 If true, will detect all peaks, do spline interpolation and plot this instead
%> @param colors =[1, 2, 3...]. See the possibilities:
%>    @arg [] : Defaults to sequential color indexes [1, 2, 3...]
%>    @arg 1-D vector : interpreted as color indexes (arguments to @ref find_color.m)
%>    @arg cell : interpreted as a cell of colours
function draw_loadings(x, L, x_hint, hint, legends, flag_abs, peakd, flag_trace_minalt, flag_draw_peaks, flag_print_peaks, flag_histogram, flag_envelope, colors)
global SCALE;
if ~exist('x_hint', 'var') || isempty(x_hint)
    x_hint = x;
end;
if ~exist('hint', 'var') || isempty(hint)
    hint = [];
end;
if ~exist('legends', 'var')
    legends = [];
end;
if ~exist('peakd', 'var')
    peakd = [];
end;
if ~exist('flag_trace_minalt', 'var') || isempty(flag_trace_minalt)
    flag_trace_minalt = 0;
end;
if ~exist('flag_abs', 'var') || isempty(flag_abs)
    flag_abs = 0;
end;
if ~exist('flag_draw_peaks', 'var') || isempty(flag_draw_peaks)
    flag_draw_peaks = 0;
end;
if ~exist('flag_print_peaks', 'var') || isempty(flag_print_peaks)
    flag_print_peaks = 0;
end;
if ~exist('flag_histogram', 'var') || isempty(flag_histogram)
    flag_histogram = 0;
end;
if ~exist('flag_envelope', 'var') || isempty(flag_envelope)
    flag_envelope = 0;
end;
if ~exist('colors', 'var') || isempty(colors)
    colors = 1:size(L, 2);
end;

% Processes colors
if iscell(colors)
    colors_eff = colors;
else
    colors_eff = arrayfun(@find_color, colors, 'UniformOutput', 0);
end;

nl = size(L, 2);
% Bonus: checks whether L is a row vector
if size(L, 1) == 1
    if nl == length(x)
        L = L'; % Daring guess; 
    else
        irerror('Loadings vector has incorrect size!');
    end;
end;
nl = size(L, 2);

% Used for the calculations
Lcalc = L;
Ltemp = Lcalc(:);
Ltemp = Ltemp(Ltemp ~= Inf);
Lcalc(Lcalc == Inf) = max(Ltemp(:)); % Inf protection

if flag_abs
    ymin = 0;
    offmin = 0;
    L = abs(L);
    Lcalc = abs(Lcalc);
else
    ymin = min(min(Lcalc));
    offmin = 0.1;
end;
ymax = max(max(Lcalc));
ymaxabs = max(max(abs(Lcalc)));
flag_bother_peaks = ~isempty(peakd) && (flag_print_peaks || flag_draw_peaks);
draw_zero_line(x);
hold on;

if flag_envelope
    opd = peakdetector();
    opd.mindist = 2;
    Lenv = L;
    for i = 1:nl
        ipe = opd.use(x, L(:, i));
%         Lenv(:, i) = spline(x(ipe), L(ipe, i), x);
        Lenv(:, i) = interp1(x(ipe), L(ipe, i), x);
    end;
end;


if ~isempty(hint)
    draw_hint_curve(x_hint, hint/max(hint)*ymaxabs);
end;



    



for i = 1:nl
    y = L(:, i)';
    
    if flag_envelope
        % Makes a fader color
        color1 = rgb(colors_eff{i});
        color1 = color1*0.3+max(color1)*0.7;
        width1 = SCALE;
        color2 = colors_eff{i};
        width2 = scaled(3);
    else
            color1 = colors_eff{i};
        width1 = scaled(2);
    end;

    
    
    if ~flag_histogram
        hh = plot_curve_pieces(x, y, 'Color', color1, 'LineWidth', width1);
        handles(i) = hh{1};
    else
        for j = 1:1 %numel(y)
            hh = stem(x, y, 'Color', color1, 'LineWidth', 2*width1, 'Marker', 'none');
            if ~flag_envelope && j == 1
                handles(i) = hh;
            end;
        end;
    end;
    hold on;
    
    if flag_envelope
        handles(i) = plot(x, Lenv(:, i)', 'Color', color2, 'LineWidth', width2);
    end;
    

    
    % Peak detectors know how to deal with Inf, need not use Lcalc
    if flag_bother_peaks
        peakd = peakd.boot(x, y);
        idxs_peaks = peakd.use([], y);
        
        if flag_draw_peaks
            draw_peaks(x, y, idxs_peaks);
        end;

        if flag_print_peaks
            if ~isempty(legends)
                s = sprintf('for ''%s''', legends{i});
            else
                s = sprintf('%d', i);
            end;
            fprintf('---------------- Peaks %s -----------------\n', s);
            print_peaks(x, idxs_peaks);
        end;
        
        % Plots "minimum altitude" line
        if flag_trace_minalt
            draw_threshold_line(x, peakd.minalt, [], colors_eff{i});
            if ~flag_abs
                draw_threshold_line(x, -peakd.minalt, [], colors_eff{i});
            end;
        end;
    end;
end;

hl = [];
if ~isempty(legends)
    hl = legend(handles, legends);
end;

% Formatting
format_frank([], [], hl);
format_xaxis(x);
ylabel('Coefficient (a.u.)');



y1 = min(ymin, 0);
if flag_abs
    yspan = ymaxabs-y1;
    y2 = ymaxabs;
else
    yspan = ymax-y1;
    y2 = ymax;
end;
if y1 == 0
    y0 = 0;
else
    y0 = y1-yspan*.025;
end;
if yspan > 0
    ylim([y0, y2+yspan*0.025]);
end;

