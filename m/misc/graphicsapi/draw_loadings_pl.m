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
%> @param flag_bmtable =0 Alternative view. If true, a completely different thing will be done: a @ref bmtable will be created. Note that the peakdetector must be provided
%> @param colorindexes =[] If passed, will use indexes to find colors and markers. Otherwise, will assume [1, 2, 3, ...]
function draw_loadings_pl(x, L, x_hint, hint, legends, flag_abs, peakd, colorindexes)
% global SCALE;
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
if ~exist('flag_abs', 'var') || isempty(flag_abs)
    flag_abs = 0;
end;

nl = size(L, 2);

if ~exist('colorindexes', 'var') || isempty(colorindexes)
    colorindexes = 1:nl;    
end;


if flag_abs
    L = abs(L);
end;


% colors and markers
arts = cell(1, nl);
for i = 1:nl
    a = bmart();
    a.color = find_color(colorindexes(i));
    a.marker = find_marker(colorindexes(i));
    a.markerscale = 1;
    arts{i} = a;
end;

% hint
dshint = [];
if ~isempty(hint)
    dshint = irdata();
    dshint.X = hint(:)';
    dshint.fea_x = x_hint;
    dshint = dshint.assert_fix();
end;

% Legends
bl = fcon_linear_fixed();
bl.L = L;
bl.L_fea_x = x;
if ~isempty(legends)
    bl.L_fea_names = legends;
    bl.title = '';
end;

% Legends for the figure. bmtable will use dataset title as legend
%
% dss will be passed to bmtable as datasets. The only property that bmtable accesses is .title anyway.
for i = 1:nl
    if isempty(legends)
        dss(i).title = sprintf('Curve %s', i);
    else
        dss(i).title = legends{i};
    end;
end;

bm = bmtable();
bm.blocks = {bl};
bm.flag_train = 0;
bm.peakdetectors = {peakd};
bm.datasets = dss;

bm.arts = arts;
bm.units = {bmunit_au};
bm.data_hint = dshint;

   
for i = nl:-1:1
    bm.grid{i, 1} = setbatch(struct(), {'i_block', 1, 'i_dataset', i, 'i_peakdetector', 1, 'i_art', i, 'i_unit', 1, 'params', {'idx_fea', i}});
end;
bm.rowname_type = 'dataset';

bm.draw_pl();
legend off;
