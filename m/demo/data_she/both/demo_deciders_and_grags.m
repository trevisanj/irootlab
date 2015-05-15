%>@brief Different ways to use per-spectrum prediction aggregation (grag), and decision thresholds (decider)
%>@ingroup demo
%>@file
%>
%> Generates 4 situations: 2 datasets x 2 analyses
%>
%> <h3>Datasets (she5trays.mat)</h3>
%> <ol>
%>   <li>Chemicals (class level 1)</li>
%>   <li>Non-transformed/transformed (class level 2)</li>
%> </ol>
%>
%> <h3>Analyses</h3>
%> <ol>
%>   <li>Classifier output is post-processed through <b>decider -> grag_classes_vote</b></li>
%>   <li>Classifier output is post-processed through <b>grag_classes_mean -> decider</b></li>
%> </ol>
%> In the first case, the decider selects which spectra will be allowed to vote, whereas
%> in the second case, the posterior probabilities (supports) per spectrum are averaged before the decider accepts or rejects a single per-group prediction.
%>
%> @sa gridsearch, decider, grag_mean, grag_classes_vote
ds = load_data_she5trays();

u = decider();
u.decisionthreshold = 0;
decider01 = u;

u = grag_mean();
grag_mean01 = u;

u = grag_classes_vote();
grag_classes_vote01 = u;

u = clssr_d();
u.type = 'linear';
u.flag_use_priors = 0;
clssr_d01 = u;

% Classifier+post-processor for first analysis
u = block_cascade();
u.blocks = {clssr_d01, decider01, grag_classes_vote01};
block_cascade01 = u;

% Classifier+post-processor for second analysis
u = block_cascade();
u.blocks = {clssr_d01, grag_mean01, decider01};
block_cascade02 = u;


u = sgs_crossval();
u.flag_group = 1;
u.flag_perclass = 0;
u.randomseed = 42424;
u.flag_loo = 0;
u.no_reps = 10;
sgs_crossval01 = u;


u = gridsearch();
u.sgs = sgs_crossval01;
u.chooser = [];
u.postpr_test = grag_mean01;
u.postpr_est = [];
u.no_refinements = 1;
u.maxmoves = 1;

gridsearch01 = u;


for i_data = 1:2
    for i_ana = 1:2
        % Select class level
        u = cascade_stdhie();
        u.blocks{2}.hierarchy = i_data;
        cascade_stdhie01 = u;
        cascade_stdhie01 = cascade_stdhie01.boot();
        out = cascade_stdhie01.use(ds);
        ds_stdhie01 = out;

        % Logs
        tt = ttlogprovider();
        logs = tt.get_ttlogs(ds_stdhie01);
        lo = estlog_rightwrong();
        lo.estlabels = ds_stdhie01.classlabels;
        lo.idx_rate = 1; % Rejected
        lo.title = 'rejected';
        logs{end+1} = lo;
       

        % Calculation;
        gridsearch01.clssr = iif(i_ana == 1, block_cascade01, block_cascade02);
        gridsearch01.paramspecs = {sprintf('blocks{%d}.decisionthreshold', iif(i_ana == 1, 2, 3)), 0:.05:.95, 0}; % 2 or 3 is the position of the decider in the sequence inside the block_cascade
        gridsearch01.log_mold = logs;
        out = gridsearch01.use(ds_stdhie01);
        log_gridsearch_gridsearch01 = out;


        % Visualization
        out = log_gridsearch_gridsearch01.extract_sovaluess();
        sov = out{1};

        
        u = blbl_extract_ds_from_sovalues();
        u.dimspec = {[0 0], [1 2]};
        u.valuesfieldname = 'rates';
        blbl_extract_ds_from_sovalues01 = u;
        out = blbl_extract_ds_from_sovalues01.use(sov);
        sov_sovalues01 = out;

        u = blbl_extract_ds_from_sovalues();
        u.dimspec = {[0 0], [1 2]};
        u.valuesfieldname = 'rejected';
        blbl_extract_ds_from_sovalues02 = u;
        out = blbl_extract_ds_from_sovalues02.use(sov);
        sov_sovalues02 = out;

        u = vis_hachures();
        vis_hachures01 = u;

        figure();
        
        subplot(2, 1, 1);
        vis_hachures01.use(sov_sovalues01);
        title(sprintf('Classes (%d): %s; Post-processor: %s --- (decision threshold) x (%%rate)', ds_stdhie01.nc, ...
            iif(i_data == 1, 'Chemicals', 'N/T'), replace_underscores([class(gridsearch01.clssr.blocks{2}), '->', class(gridsearch01.clssr.blocks{3})])));
        legend off;
        xlabel('');
        
        subplot(2, 1, 2);
        vis_hachures01.use(sov_sovalues02);
        ylabel('Rejected (%)');
        title('(decision threshold) x (%rejected)');
        legend off;
        
        maximize_window();
        save_as_png([], sprintf('irr_dataset%02d_analysis%02d', i_data, i_ana));
    end;
end;

