%> @brief Shows how to assemble a dataset from existing MATLAB matrices (Fisher Iris data example)
%> @ingroup demo
%> @file
%>
%> Loads the "Fisher Iris" dataset that comes with MATLAB Statistics Toolbox

load fisheriris; % Gives the "meas" and "species" variables

ds = irdata();
ds.X = meas;

ds.classlabels = unique(species(:))'; % Class labels: row vector
for i = 1:numel(ds.classlabels)
    ds.classes(strcmp(species, ds.classlabels{i}), 1) = i-1;
end;

ds.fea_names = {'sepal length', 'sepal width', 'petal length', 'petal width'};
ds.xname = 'Characteristics';
ds.yunit = '';
ds.yname = 'Measure';
ds.yunit = '?';
ds = ds.assert_fix(); % Checks for matching dimensions; auto-creates the class labels

%%

% Visualization

u = vis_scatter2d();
u.idx_fea = 1:4;
u.confidences = [];
u.textmode = 0;
vis_scatter2d01 = u;
figure;
vis_scatter2d01.use(ds);
maximize_window();
save_as_png([], 'irr_fisheriris_scatter2d');

%%

% Rater

u = decider();
u.decisionthreshold = 0;
decider01 = u;

u = rater();
u.clssr = [];
u.sgs = [];
u.ttlog = [];
u.postpr_est = decider01;
u.postpr_test = [];
rater01 = u;
out = rater01.use(ds);
estlog_classxclass_rater01 = out;



%%

% Confusion matrix

out = estlog_classxclass_rater01.extract_confusion();
irconfusion_classxclass01 = out;

u = vis_balls();
vis_balls01 = u;
figure;
vis_balls01.use(irconfusion_classxclass01);
maximize_window([], 1);
set(gca, 'position', [0.2316    0.1100    0.6734    0.6047]);