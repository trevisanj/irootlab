%> @brief Shows different ways to paint the same Feature Histogram
%> @ingroup demo
%> @file
fig_assert();
% The dataset
ds = load_data_she5trays();
ds = data_select_hierarchy(ds, 2); % Classes: N/T

% The classifier
o = clssr_d();
o.type = 'linear';
clssr_d01 = o;

% The FSG
o = fsg_clssr();
o.clssr = clssr_d01;
o.estlog = [];
o.postpr_est = [];
o.postpr_test = [];
o.sgs = [];
fsg_clssr01 = o;

% The object that will do the feature selection
ofs = as_fsel_forward();
ofs.nf_select = 10; % <-------- Number of features to be selected
ofs.fsg = fsg_clssr01;

% The SGS
osgs = sgs_randsub();
osgs.flag_group = 0;
osgs.flag_perclass = 0;
osgs.randomseed = 0;
osgs.no_reps = 50; % <-------- Number of repetitions for the histogram

% The Feature Selection Repeater
orep = fselrepeater();
orep.sgs = osgs;
orep.as_fsel = ofs;

%%

log_rep = orep.use(ds); % This is the time-consuming line

%%

%> Stability and nf x grade
global SCALE;
SCALE = .8;

ds_nfxgrade = log_rep.extract_dataset_nfxgrade();
ds_stab = log_rep.extract_dataset_stabilities();

ov = vis_alldata();

figure;
subplot(2, 1, 1);
ov.use(ds_nfxgrade);
legend off;
subplot(2, 1, 2);
ov.use(ds_stab);
legend off;

maximize_window(gcf(), .8);
%%
SCALE = 1;

ov = vis_stackedhists();
ov.data_hint = ds;

ssp = subsetsprocessor();

% Plots histogram in 3 different styles
figure;
for i = 1:3
    if i == 1
        %> All features are informative
        ssp.nf4grades = [];
        ssp.nf4gradesmode = 'fixed';
        ov.colors = []; % Uses default color scheme from colors2map(), which accesses COLOR_STACKEDHISTS
    elseif i == 2
        %> 4 features are informative
        ssp.nf4grades = 4;
        ssp.nf4gradesmode = 'fixed';
        ssp.stabilitythreshold = 0.05;
        ov.colors = [];
    elseif i == 3
        %> Same as previous but with different color scheme
        ssp.nf4grades = 4;
        ssp.nf4gradesmode = 'fixed';
        ssp.stabilitythreshold = 0.05;
        ov.colors = {[.6, 0, 0], [1, 0, 0], [.7, .7, .7], [.9, .9, .9]};
    end;
    log_ssp = ssp.use(log_rep);
    
    subplot(3, 1, i);
    ov.use(log_ssp); % .draw_stackedhists(ds, colors, []);
    freezeColors();
end;
maximize_window(gcf(), 1.5);
save_as_png([], 'irr_histogram_colors');
