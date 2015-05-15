%>@brief Plots all sample datasets in separate figures
%>@file
%>@ingroup demo sampledata

d = dir(fullfile(get_rootdir(), 'demo', 'sampledata', '*.mat'));
filenames = {d.name};
ov = vis_alldata();
for i = 1:numel(filenames)
    figure();
    ov.use(load_sampledata(filenames{i}));
    [qw, as, zx] = fileparts(filenames{i});
    title(replace_underscores(as));
    maximize_window([], [], .618);
    save_as_png([], ['irr_allcurves_', as]);
end;

