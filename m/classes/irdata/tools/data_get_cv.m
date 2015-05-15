%>@ingroup datasettools
%> @file
%> @brief Calculates the "cluster vectors"
%>
%> <h3>References</h3>
%> (1) Binary Mixture Effects by PBDE Congeners (47, 153, 183, or 209) and PCB Congeners (126 or 153) in MCF-7 Cells: 
%> Biochemical Alterations Assessed by IR Spectroscopy and Multivariate Analysis. Valon Llabjani, Julio Trevisan,
%> Kevin C. Jones, Richard F. Shore, Francis L. Martin. ES&T, 2010, 44 (10), 3992-3998.
%>
%> (2) Martin FL, German MJ, Wit E, et al. Identifying variables responsible for clustering in discriminant analysis of
%> data from infrared microspectroscopy of a biological sample. J. Comp. Biol. 2007; 14(9):1176-84.

%> @param data @ref irdata object. Input dataset. This dataset is transformed into the L/factor space, then the average spectrum for each class
%>             is calculated. The vectors stretched in the factor space between (the origin / the average of a reference class) and (the average
%>             of a target class) become the coefficients of a linear combination of the columns of L to give the cluster vectors.
%>   @attention If <code>idx_class_origin <= 0</code>, @c data <b>will be mean-centered</b>
%> @param L Loadings matrix
%> @param idx_class_origin Index of class to be considered the origin of the space (1). If <= 0, classical cluster
%>                         vectors will be calculated (2), i.e., the cluster vectors origin is the origin of the space.
%>
%> @return \em cv Cluster vectors, dimensions [\ref nf]x[\ref nc]
function cv = data_get_cv(data, L, idx_class_origin)
if ~exist('idx_class_origin', 'var')
    idx_class_origin = 0;
end;

if idx_class_origin == 0
    % checks if mean-centered; if not, does it
    flag_ok = 0;
    try
        assert_meancentered(data.X);
        flag_ok = 1;
    catch ME
        irverbose(sprintf('Will mean-center the dataset NOW (failed mean-centered test with error message "%s")!', ME.message), 2);
    end;
    
    if ~flag_ok
        data.X = normaliz(data.X, [], 'c');
        assert_meancentered(data.X);
        
    end;
end;


if data.nf ~= size(L, 1)
    irerror(sprintf('Input dataset (nf=%d) incompatible with loadings matrix (nf=%d)', data.nf, size(L, 1)));
end;

pieces = data_split_classes(data);

if idx_class_origin > 0
    v_shift = -(mean(pieces(idx_class_origin).X, 1)*L)';
else
    v_shift = 0;
end;

cv = zeros(data.nf, data.nc);
for k = 1:data.nc
    m = (mean(pieces(k).X, 1)*L)';
    cv(:, k) = L*(m+v_shift); % Linear combination of loadings vectors here
end;
