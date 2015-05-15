%> This is a property repository
%>
%> What you are going to do with this output structure, it is entirely your choice!
classdef sosetup
    properties
        % This part of the code was generated back by code_props()
        % |
        % |
        % |

        
        %> ANN architecture optimization - List of numbers of features to assign to feature extraction block
        clarchsel_ann_nfs =  -1;
        %> ANN architecture optimization - List of candidate ANN architectures
        clarchsel_ann_archs =  {1, 3, 5, 10, 15, 20, 30, [7 4], [10 5], [10 9], [20 11]};
        %> SVM architecture optimization - List of numbers of features to assign to feature extraction block
        clarchsel_svm_nfs =  -1;
        %> SVM architecture optimization - List of candidate "C" parameters (Gaussian kernel)
        clarchsel_svm_cs = 10.^(2:.25:5);
        %> SVM architecture optimization - List of candidate "gamma" parameters (Gaussian kernel)
        clarchsel_svm_gammas = 10.^(-7:.5:-1);
        %> FRBM (Fuzzy classifie) architecture optimization - List of numbers of features to assign to feature extraction block
        clarchsel_frbm_nfs =  -1;
        %> k-NN architecture optimization - List of numbers of features to assign to feature extraction block
        clarchsel_knn_nfs =  -1;
        %> k-NN architecture optimization - List of candidate "k"s (number of neighbors)
        clarchsel_knn_ks =  [1 2 3 5 7 11 13 15 17];
        %> LASSO architecture optimization - List of numbers of features
        clarchsel_lasso_nfs = [1, 2, 3, 5:2:15, 18:3:36, 40:4:152];
        %> Feature Extraction optimization - FFS(classifier) - maximum number of features
        fearchsel_ffs_nf_max =  50;
        %> Feature Extraction optimization - FFS(MANOVA) - maximum number of features
        fearchsel_manova_nf_max =  50;
        %> Feature Extraction optimization - Fisher criterion-based FS - maximum number of features
        fearchsel_fisher_nf_max =  50;
        %> Feature Extraction optimization - LASSO embedded FS - maximum number of features
        fearchsel_lasso_nf_max =  50;
        %> Feature Extraction optimization - PCA - list of numbers of features
        fearchsel_pca_nfs = [1:9, 11:2:151];
        %> Feature Extraction optimization - PLS - list of numbers of features
        fearchsel_pls_nfs = [1:9, 11:2:151];
        %> Feature Extraction optimization - B-Spline Representation - list of numbers of features
        fearchsel_spline_nfs =  6:70;
        %> Undersampling optimization - All classification methods - List of number of classifiers trained with undersampled data
        undersel_unders =  [1 2 3 4 5 7 9];
        %> Feature Histogram Generation - FFS(classifier) - number of features to select
        fhg_ffs_nf_select =  10;
        %> Feature Histogram Generation - LASSO embedded FS - number of features to select
        fhg_lasso_nf_select =  10;
        %> Feature Histogram Generation - FFS(MANOVA) - number of features to select
        fhg_manova_nf_select =  10;
        %> Feature Histogram Generation - FS-Fisher - number of peaks to pick from Fisher feature grades curve
        fhg_fisher_nf_select =  10;
        %> Feature Histogram Generation - PCA-LDA - number of peaks to pick from PCA-LDA loadings vector
        fhg_pcalda_nf_select =  10;
        %> Feature Histogram Generation - LDA - number of peaks to pick from LDA loadings vector
        fhg_lda_nf_select =  10;
    end;
    
    % Properties that don't get published in sosetup_scene.m
    properties
        %> Manifests an intention to parallelize code whenever possible
        flag_parallel = 0;
        
        %> randomseed for the undersampling sgs
        under_randomseed = 0;
        
        %> This is set in goer_fhg_pcalda*.m
        fhg_pcalda_no_factors = NaN;

        % LSTH properties
        clarchsel_lsth_nfs = NaN;

        lcr2_no_folds = 50;
        lcr2_subdspercs = [.1, .15, .2:.1:1];

        %> Maximum percentage of total number of diagnosissystem's to include in the majority vote classifier
        committees_maxperc = 0.5;
    end;

    % Objects as properties
    properties
        %> a dataloader_she object (that needs to be tuned for the specific dataset classes (NT/NDI/Trai))
        dataloader;
        
        %> a subdatasetprovider object containing only one subdataset percentage: 100%!
        subdatasetprovider;
        
        %> a sostage_pp object (currently Rubberband -> Amide I normalization) that can be used to retrieve a Pre-processing when needed
        sostage_pp;
        
        %> a sostage_fe object (currently PLS - partial Least Squares) that can be used to retrieve a feature extractor to be used for classifier design
        sostage_fe;

        %> a sostage_cl object (currently LDC) 
        sostage_cl;
        
        %> a cubeprovider object with 10 reps, NOT parallel, with 0 randomseed, and, perhaps most important: a DEFAULT
        %>      TTLOGPROVIDER of @ref ttlogprovider class (other classifiers, such as FRBM or SVM would like to use a custom logprovider)
        cubeprovider;
        
        %> chooser object to be used for "results reduction" (Example: @ref ropr_1perarch objects
        clarchsel_chooser;
        
        %> Chooser for the algorithm-independent design
        undersel_chooser;

        %> chooser object to be used for the Feature Extraction Design step
        fearchsel_chooser;

        %> chooser object to be used for final single choice.
        diacomp_chooser;
    end;
    
    
    methods
        %> Constructor
        function o = sosetup()
            %-----
            %----- Data loader setup
            %-----
            dl = []; %dataloader();
            o.dataloader = dl;

            %=== Subdataset Provider setup
            %===
            sdp = subdatasetprovider();
            sdp.subdspercs = [1];
            sdp.randomseed = 0;
            o.subdatasetprovider = sdp;
            
            %=== Pre-processing sostage_pp
            %===
            spp = sostage_pp_rubbernorm();
            spp.nf_resample = 0;  % Note that the default is not to resample
            % The normalization defaults to Vector because Amide I was giving trouble
            % after feature averaging
            spp.normtypes = 'n'; % Vector normalization!
            o.sostage_pp = spp;

            %=== Feature Extraction sostage_fe setup
            %===
%             sfe = sostage_fe_pls();
%             sfe.nf = 10; % Arbitrary
            sfe = sostage_fe_bypass();
            o.sostage_fe = sfe;
            
            %=== Classification sosstage_cl setup
            %===
            scl = sostage_cl_ldc();
            scl.flag_cb = 1;
            o.sostage_cl = scl;
            
            %=== Cubeprovider setup
            %===
            cp = cubeprovider(); %#ok<*CPROP,*PROP>
            cp.no_reps = 10;            
            cp.no_reps_fhg = 10;
            cp.no_reps_stab = 1;
            cp.flag_parallel = 0;
            cp.randomseed = 0;
            cp.randomseed_stab = 1928396; % arbitrary number
            cp.ttlogprovider = ttlogprovider();
            o.cubeprovider = cp;
            
            %=== Choosers setup
            %===
            %-----
            %----- Chooser CLARCHSEL1
            %-----
            ch1 = chooser();
            ch1.rate_maxloss = .01; % 1% default
            ch1.time_pvalue = 0.05;
            ch1.time_mingain = .25; % 25% default
            ch1.vectorcomp = vectorcomp_ttest_right();
            ch1.vectorcomp.flag_logtake = 0;

            %-----
            %----- Chooser UNDERSEL
            %-----
            ch2 = chooser();
            ch2.rate_maxloss = .01;
            ch2.time_pvalue = 0.05;
            ch2.time_mingain = .25;
            ch2.vectorcomp = vectorcomp_ttest_right();
            ch2.vectorcomp.flag_logtake = 0;
            
            %-----
            %----- Chooser for FEARCHSEL
            %-----
            ch3 = chooser();
            ch3.rate_maxloss = .01;
            ch3.time_pvalue = 0.05;
            ch3.time_mingain = .25;
            ch3.vectorcomp = vectorcomp_ttest_right();
            ch3.vectorcomp.flag_logtake = 0;

            % Conservative chooser
            cc = ch3;
            cc.rate_maxloss = 0.002;
            
            
            o.clarchsel_chooser = ch1;
            o.undersel_chooser = ch2;
            o.fearchsel_chooser = ch3;
            o.diacomp_chooser = cc;

            o = o.setup_from_env();
        end;


        
        %> Sets up properties according to the current directory
        %> Sets up some properties according to environment variables FLAG_PARALLEL and FLAG_SKIP_EXISTING
        function o = setup_from_env(o)
            % Checks whether it is possible to parallelize
            % primary information about parallelization will be the FLAG_PARALLEL environment variable
            flag = getenv('FLAG_PARALLEL');
            flag = ~isempty(flag) && str2double(flag); 
            flag = flag && license('test', 'distrib_computing_toolbox');
            o.flag_parallel = flag;
        end;
        
        function a = get_propsmap(o) %#ok<*MANU>
            a = {...
'sostage_pp.nf_resample' , 'Resampling to reduce initial number of features within pre-processing. If set as <= 0, does not resample';
'clarchsel_ann_archs', 'ANN architecture optimization - List of candidate ANN architectures';
'clarchsel_ann_nfs', 'ANN architecture optimization - List of numbers of features to assign to feature extraction block';
'clarchsel_svm_cs', 'SVM architecture optimization - List of candidate "C" parameters (Gaussian kernel)';
'clarchsel_svm_gammas', 'SVM architecture optimization - List of candidate "gamma" parameters (Gaussian kernel)';
'clarchsel_svm_nfs', 'SVM architecture optimization - List of numbers of features to assign to feature extraction block';
'clarchsel_frbm_nfs', 'FRBM (Fuzzy classifier) architecture optimization - List of numbers of features to assign to feature extraction block';
'clarchsel_knn_ks', 'k-NN architecture optimization - List of candidate "k"s (number of neighbors)';
'clarchsel_knn_nfs', 'k-NN architecture optimization - List of numbers of features to assign to feature extraction block';
'clarchsel_lasso_nfs', 'LASSO architecture optimization - List of numbers of features';
'fearchsel_ffs_nf_max', 'Feature Extraction optimization - FFS(classifier) - maximum number of features';
'fearchsel_manova_nf_max', 'Feature Extraction optimization - FFS(MANOVA) - maximum number of features';
'fearchsel_fisher_nf_max', 'Feature Extraction optimization - Fisher criterion-based FS - maximum number of features';
'fearchsel_lasso_nf_max', 'Feature Extraction optimization - LASSO embedded FS - maximum number of features';
'fearchsel_pca_nfs', 'Feature Extraction optimization - PCA - list of numbers of features';
'fearchsel_pls_nfs', 'Feature Extraction optimization - PLS - list of numbers of features';
'fearchsel_spline_nfs', 'Feature Extraction optimization - B-Spline Representation - list of numbers of features';
'undersel_unders', 'Undersampling optimization - All classification methods - List of number of classifiers trained with undersampled data';
'fhg_ffs_nf_select', 'Feature Histogram Generation - FFS(classifier) - number of features to select';
'fhg_lasso_nf_select', 'Feature Histogram Generation - LASSO embedded FS - number of features to select';
'fhg_manova_nf_select', 'Feature Histogram Generation - FFS(MANOVA) - number of features to select';
'fhg_fisher_nf_select', 'Feature Histogram Generation - FS-Fisher - number of peaks to pick from Fisher feature grades curve';
'fhg_pcalda_nf_select', 'Feature Histogram Generation - PCA-LDA - number of peaks to pick from PCA-LDA loadings vector';
'fhg_lda_nf_select', 'Feature Histogram Generation - LDA - number of peaks to pick from LDA loadings vector';
'cubeprovider.no_reps_fhg', 'Feature Histogram Generation - Number of feature selection repetitions per fold of the outer cross-validation loop';
};
        end;
        
        function s = get_propscode(o)
            props = o.get_propsmap();
            s = code_props(o, props);
        end;
    end;
end

