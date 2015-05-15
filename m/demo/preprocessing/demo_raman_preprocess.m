%>@brief Pre-processing of Raman data: Wavelet-De-noising, Polynomial Baseline Correction, Vector Normalization
%>@file
%>@ingroup demo

ds01 = load_data_raman_sample();

% Wavelet de-noising
u = pre_wden();
u.waveletname = 'haar';
u.no_levels = 6;
u.thresholds = [0 0 0 20 20 100];
pre_wden01 = u;

out = pre_wden01.use(ds01);
ds01_wden01 = out;


% Polynomial baseline correction
u = pre_bc_poly();
u.order = 5;
u.epsilon = 0;
u.contaminant_data = [];
u.contaminant_idxs = 1;
pre_bc_poly01 = u;

out = pre_bc_poly01.use(ds01_wden01);
ds01_wden01_poly01 = out;


u = fsel();
u.v_type = 'rx';
u.flag_complement = 0;
u.v = [1725, 600];
fsel01 = u;
out = fsel01.use(ds01_wden01_poly01);
ds01_wden01_poly01_fsel01 = out;

u = pre_norm_vector();
pre_norm_vector01 = u;
out = pre_norm_vector01.use(ds01_wden01_poly01_fsel01);
ds01_wden01_poly01_fsel01_vector01 = out;



%%

% Visualization

fig_assert();
global SCALE FONTSIZE;
FONTSIZE = 14;
SCALE = 1.3;

u = vis_alldata();
vis_alldata01 = u;

figure;

subplot(2, 2, 1);
vis_alldata01.use(ds01);
title('Raw Raman spectra');
legend off;
xlabel('');

subplot(2, 2, 2);
vis_alldata01.use(ds01_wden01);
title('1. After Wavelet de-noising, 5^{th}-order polynomial baselines');
legend off;
h = plot(ds01_wden01.fea_x, (ds01_wden01.X-ds01_wden01_poly01.X)', 'LineWidth', scaled(1), 'Color', find_color(2));
hl = legend(h, {'Baselines'});
format_frank([], [], hl);
xlabel('');
ylabel('');

subplot(2, 2, 3);
vis_alldata01.use(ds01_wden01_poly01);
title('2. After Polynomial baseline correction');
legend off;

subplot(2, 2, 4);
vis_alldata01.use(ds01_wden01_poly01_fsel01_vector01);
title('3. After Cut 1725-600 cm^{-1} --> Vector normalization');
legend off;
ylabel('');

maximize_window();