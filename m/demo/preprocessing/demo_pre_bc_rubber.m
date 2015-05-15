%> @brief Demonstrates the Convex Polynomial Line baseline correction
%> @ingroup demo
%> @file

x = load_data_uglyspectrum();

opre = pre_bc_rubber();
opre.flag_trim = 0;

y = opre.use(x);

figure;
fig_assert();
global SCALE;
SCALE = 1;
draw_zero_line(x.fea_x);
hold on;
h = [];
h(1) = plot(x.fea_x, x.X, 'LineWidth', 4, 'Color', 'r');
h(2) = plot(x.fea_x, x.X-y.X, 'LineWidth', 4, 'Color', 'k');
h(3) = plot(x.fea_x, y.X, 'LineWidth', 4, 'Color', [0, 0.65, 0]);
legend(h, {'Original', 'Baseline', 'Corrected'});
title('Rubberband baseline correction demonstration');
format_xaxis(x);
format_frank();
make_box();
maximize_window([], [], 0.6);
save_as_png([], 'irr_bc_rubber');
