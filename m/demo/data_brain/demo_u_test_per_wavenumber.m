%> @brief U-test per wavenumber is performed for one-versus-one datasets (2-class datasets)
%> @file
%> @ingroup demo

ds = load_data_ketan_brain_atr();

%Dataset load
ds01 = load_data_ketan_brain_atr();
u = vis_alldata();
vis_alldata01 = u;
figure;
vis_alldata01.use(ds);

u = fsg_test_u();
u.flag_logtake = 1;
fsg_test_u01 = u;

% Splits in 3
u = blmisc_split_ovo();
u.hierarchy = [];
blmisc_split_ovo01 = u;
pieces = blmisc_split_ovo01.use(ds);
ds_ovo01_01 = pieces(1);
ds_ovo01_02 = pieces(2);
ds_ovo01_03 = pieces(3);


% Performs U-test on pieces
figure();
for i = 1:numel(pieces)
    u = as_grades_fsg();
    u.fsg = fsg_test_u01;
    as_grades_fsg01 = u;
    out = as_grades_fsg01.use(pieces(i));
    log_grades_fsg01 = out;

    u = as_fsel_grades();
    u.type = 'threshold';
    u.nf_select = 10;
    u.threshold = -log10(0.05);
    u.peakdetector = [];
    u.sortmode = 'index';
    as_fsel_grades01 = u;
    out = as_fsel_grades01.use(log_grades_fsg01);
    log_as_fsel_grades_grades01 = out;

    u = vis_log_as_fsel();
    u.data_hint = ds;
    u.flag_mark = 0;
    vis_log_as_fsel01 = u;
    subplot(3, 1, i);
    vis_log_as_fsel01.use(log_as_fsel_grades_grades01);
    title(pieces(i).title);
    if i < numel(pieces)
        xlabel('');
    end;
    maximize_window([], 1);
end;
save_as_png([], sprintf('irr_u_test_per_wavenumber'));
