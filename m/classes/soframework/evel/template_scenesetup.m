%> This file is used by @ref start_scene.m to create a new scenesetup.m file
% Configuration of database, scene name, dataset, reference class,
% cross-validation "k", and methods to be executed.
%
% Please note that if anything is changed to this file, the database tasks will
% need to be rebuilt.
a = scenebuilder(); % do not change this line

%===
%=== Dataset setup
%===
% If you change any of these options, the dataset splits will have to be
% re-generated apart from the database tasks.

% File name of your dataset. This can be in any dataset that can be opened in
% objtool. Full path or relative path can be used, e.g.,
%    'c:\users\...\dataset.mat', '..\dataset.mat'
a.filename = './your_file_name.mat';
% "reference" class. This must be a valid class label within the dataset
% specified above.
a.reflabel = 'CONTROL';
% Cross-validation "k"
a.crossval_k = 10;

%===
%=== MySQL Database setup
%===

% database host
a.db_host = 'bioph.lancs.ac.uk';
% database name
a.db_name = 'taskman';
% Name of the data analysis "scene". This is a name to find and monitor the
% analysis progress at http://bioph.lancs.ac.uk/taskman. Please note that if you
% specify a scene name that already exists on the database at bioph.lancs.ac.uk,
% that may delete or mix up the existing scene.
a.scenename = 'your_scene_name';

%===
%=== Analysis methods setup
%===

% List of "wrapper" classifiers to use. They will be tried in combination with
% all the "fe" options below.
%
% Available options:
%     'ldc' - Linear Discriminant Classifier (LDA in [1])
%     'qdc' - Quadratic Discriminant Classifier (QDA in [1])
%     'knn' - k-Nearest Neighbors [1]
%     'ann' - Artificial Neural Network [2]. Warning: time-consuming!
%     'svm' - Support Vector Machine [3]. Warning: time-consuming!
%     'frbm_ori' - Original fuzzy eClass classifier. Warning: time-consuming!
%     'dist'- distance classifier [4]
a.clwrapper = {'ldc', 'qdc', 'knn'};

% List of feature extraction methods. They will be tried in combination with all
% the "clwrapper" options above.
% Available options:
%     'pca' - Principal Component Analysis [5]
%     'pls' - Partial Least Squares [1]
%     'spline' - B-splines representation [6]
%     'lasso' - LASSO-based feature selection [1]
%     'fisher' - Univariate feature selection using the Fisher criterion [7]
%                and peak detection
%     'manova' - Forward Feature Selection (FFS) using MANOVA p-values as
%                selection criterion [----]
%     'bypass' - no feature extraction (output data=input data); called
%                "identity" in [8]
%
a.fe = {'pca', 'pls', 'spline', 'lasso', 'fisher', 'manova', 'bypass'};


% List of classifiers that have feature selection embedded in them. Currently,
% the only option here is 'lasso' [1]
a.clembedded = {'lasso'};

% Feature Histogram Generation (FHG) options

% List of classifiers to guide wrapper feature selection methods defined in
% fhg_fswrapper_fs below. The available options are the same as in
% "clwrapper" above. Beware of time-consuming classifiers!
a.fhg_fswrapper_cl = {};
% List of wrapper feature selection methods to be used in combination with
% each of the classifiers defined in fhg_fswrapper_cl above. Available options:
%     'ffs' - Forward feature selection
a.fhg_fswrapper_fs = {};

% Stabilization for FHG using Wrapper feature selection (WFS) + classifier.
% 0 (zero) means no stabilization, whereas a number >=2 creates an internal
% subsampling loop that stabilizes FFS.
%
% This parameter only has effect if fhg_fswrapper_cl and fhg_fswrapper_fs above
% are not empty.
a.fhg_stab = [0, 2, 10];

% Other FHG methods not using FFS. Available options:
%     'fisher' - Univariate feature selection using the Fisher criterion [7]
%                and peak detection 
%     'manova' - Forward Feature Selection (FFS) using MANOVA p-values as
%                selection criterion
%     'lasso' - LASSO-based feature selection [1]
%     'lda' - features picked from first LDA loadings vector using peak
%             detection
%     'pcalda10' - PCA-LDA with number of PCs = 10; features picked from first
%                  PCA-LDA loadings vector using peak detection
%     'pcalda20' - PCA-LDA with number of PCs = 20; features picked from first
%                  PCA-LDA loadings vector using peak detection
a.fhg_others = {};




% References
% [1] Hastie, T., Friedman, J. H., & Tibshirani, R. (2007). The Elements of
%     Statistical Learning (2nd ed.). New York: Springer.
% [2] Mathworks (2000). Neural Network Toolbox.
% [3] Hsu, C., Chang, C., & Lin, C. (2010). A Practical Guide to Support Vector
%     Classification. Bioinformatics, 1(1), 1–16.
% [4] Jain, A. K., & Duin, P. W. (2000). Statistical pattern recognition: a
%     review. IEEE T. Pattern. Anal., 22(1), 4–37. doi:10.1109/34.824819
% [5] Kelly, J. G., Trevisan, J., Scott, A. D., Carmichael, P. L., Pollock,
%     H. M., Martin-Hirsch, P. L., & Martin, F. L. (2011). Biospectroscopy to
%     metabolically profile biomolecular structure: a multistage approach
%     linking computational analysis with biomarkers. J. Proteome Res., 10(4),
%     1437–1448. doi:10.1021/pr101067u
% [6] Ramsay, J., Hooker, G., & Graves, S. (2009). Functional Data Analysis with
%     R and MATLAB. Media. New York: Springer. doi:10.1007/978-0-387-98185-7
% [7] Guyon, I., & Elisseeff, A. (2003). An Introduction to Variable and
%     Feature Selection. (L. P. Kaelbling, Ed.) Journal of Machine Learning
%     Research, 3(7-8), 1157–1182. doi:10.1162/153244303322753616
% [8] Gajjar, K., Trevisan, J., Owens, G., Keating, P. J., Wood, N. J.,
%     Stringfellow, H. F., Martin-Hirsch, P. L., et al. (2013). Fourier-
%     transform infrared spectroscopy coupled with a classification machine for
%     the analysis of blood plasma or serum: a novel diagnostic approach for
%     ovarian cancer. Analyst, In press. doi:10.1039/c3an36654e
