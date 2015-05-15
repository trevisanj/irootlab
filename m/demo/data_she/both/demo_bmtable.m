%>@brief Biomarkers of Non-transformed vs. Transformed, separated by Chemical
%>
%> Splits SHE dataset in 5 (1 per chemical) and proceeds with separate biomarkers analyses for each dataset. Each of five datasets has
%> 2 classes: Non-transformed/Transformed
%>
%> Four different biomarkers identification methods are applied for comparison
%>
%>@file
%>@ingroup demo

% Initialization
fig_assert;
global FONTSIZE SCALE;
FONTSIZE = 13;
SCALE = 1.8;




%%%%%%%%% Dataset
ds01 = load_data_she5trays;

pieces = data_split_classes(ds01, 1); % Splits by tray. Each piece will have two classes: Non-transformed vs Transformed
nop = numel(pieces);
for i = 1:nop
    pieces(i).X = normaliz(pieces(i).X, [], 's');
    cl = pieces(i).classlabels{1};
    pieces(i).title = cl(1:find(cl == '|')-1);
end;



%%%%%%%%% FOUR DIFFERENT METHODS ...



%%%%% ... 11111 PCA-LDA ...
o = cascade_pcalda();
o.blocks{1}.no_factors = 10;
cascade_pcalda01 = o;


% 
% 
% %%%%%% ... 22222 U-test ...
u = fsg_test_u();
u.flag_logtake = 1;
fsg_test_u01 = u;

u = cascade_fsel_grades_fsg();
u.blocks{1}.fsg = fsg_test_u01;
u.blocks{2}.type = 'none';
u.blocks{2}.nf_select = 10;
u.blocks{2}.threshold = 0.07;
u.blocks{2}.peakdetector = [];
u.blocks{2}.sortmode = 'grade';
cascade_fsel_grades_fsg01 = u;
cascade_fsel_grades_fsg01 = cascade_fsel_grades_fsg01.boot();
cascade_fsel_grades_fsg01 = cascade_fsel_grades_fsg01.train(ds01);
out = cascade_fsel_grades_fsg01.use(ds01);
fsel_fsg01 = out;

tr = mutant();
tr.block = cascade_fsel_grades_fsg01;


%%%%%% ... 33333 LDA only ...
fcon_lda01 = fcon_lda();



%%%%%% ... 44444 PLS ...

% PLS block has a fcon_feaavg block before, just to show that bmtable is able to assimilate cases when
% different blocks work with different x-axis
fcon_pls01 = fcon_pls();
cascade_pls = block_cascade_base();
cascade_pls.blocks = {fcon_feaavg(), fcon_pls01};
% fcon_pls01.flag_autostd = 1;




%%%%%% The peak detector
o = peakdetector();
o = o.setbatch({'flag_perc', 1, ...
'flag_abs', 1, ...
'minaltitude', 0, ...
'minheight', 0, ...
'mindist', 3, ...
'no_max', 6});
peakdetector01 = o;



%%%%%% The bmtable
bm = bmtable();
bm.blocks = {cascade_pcalda01, fcon_lda01, cascade_pls, tr};
bm.datasets = pieces;
bm.peakdetectors = {peakdetector01};
bm.arts = {bmart_circle, bmart_diamond, bmart_pentagram, bmart_square};
bm.units = {bmunit_au, bmunit_int}; % au for pca-lda loadings and t-test; int for the histogram
bm.data_hint = ds01;
bm.rowname_type = 'dataset';
bm.sig_j = [4, 4, 4, 4];
bm.sig_threshold = -log10(0.05);
bm.flag_train = 1;
iunits = [1, 1, 1, 1];



% Set up the grid
for idata = 1:nop
    for iblock = 1:numel(bm.blocks)
        bm.grid{idata, iblock} = setbatch(struct(), {'i_block', iblock, 'i_dataset', idata, 'i_peakdetector', 1, 'i_art', ...
            iblock, 'i_unit', iunits(iblock), 'params', {'flag_abs', iblock == 2}, 'flag_sig', iblock == 2});
    end;
end;



%-%
%-%
figure;
bm.draw_pl();
title('All chemicals');
maximize_window();
save_as_png([], 'irr_peak-locations-plot');
% return;
%-%
for i = 1:nop
    figure;
    bm.draw_lines(i);
    t = pieces(i).title;
    if isempty(t)
        t = sprintf('Dataset %d - classlabels=', i, cell2str(pieces(i).classlabels));
    end;
    title(t);
    legend off;
    maximize_window();
    save_as_png([], good_filename(t));
%     break;
end;
