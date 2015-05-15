% Log filename: /home/j/Documents/phd/evel/m/irootlab-development/irootlab/trunk/m/gui/auxi/irr_macro_0001.m
u = peakdetector();
u.flag_perc = 1;
u.flag_abs = 1;
u.minaltitude = 0;
u.minheight = 0;
u.mindist_units = 31;
u.no_max = 0;
peakdetector01 = u;

u = vis_means();
u.peakdetector = peakdetector01;
vis_means01 = u;
figure;
vis_means01.use(ds01);

u = vis_means();
u.peakdetector = [];
vis_means02 = u;
figure;
vis_means02.use(ds01);

