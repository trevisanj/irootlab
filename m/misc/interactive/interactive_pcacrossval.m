%>@ingroup interactive
%>@file
%>@brief PCA cross-validation aims to determine the "best" number of PCs to use in PCA
%>
%> Sense of "best": the number of PCs that give minimum mean reconstruction error
%>
%> <h3>What is reconstruction error?</h3>
%> <ul>
%>   <li> PCA scores are calculated using the loadings matrix: Y = X*L, where
%>     <ul>
%>       <li> X is the testing dataset (spectra horizontally)</li>
%>       <li> Y is the PCA scores dataset</li>
%>       <li> L is the loadings matrix (loadings vertically) calculated from the training dataset</li>
%>     </ul></li>
%>   <li> Spectra can be reconstructed [with error] by <code>X_hat = Y*L' = X*L*L'</code>
%>   <li> The reconstruction error is calculated as error = mean_all_i(norm^2(X_hat_i-X_i)), where
%>     <ul>
%>       <li> mean_all_i(.) is the mean of all spectra in the testing dataset</li>
%>       <li> X_i is the i-th spectrum (row) in the testing dataset</li>
%>       <li> X_hat_i is the i-th reconstructed spectrum (row) of the testing dataset</li>
%>     </ul>
%>   </li>
%> </ul>
%>
%> <h3>Why cross-validation?</h3>
%> If you measure reconstruction error using the same dataset for training and testing, the error will probably always decrease
%> as you add more PCs to Y.
%>
%> However, if we split the dataset into training and testing datasets, we will try to reconstruct samples that have been
%> left out of training. It may happen adding that PCs degrades the generalization of the model (loadings).
%>
%> <h3>The meaning of k-fold:</h3>
%> 
%> First, suppose you have a dataset with, say, 500 spectra.
%> 
%> <ul>
%>   <li> 10-fold means that the cross-validation will split the 500 spectra 10 times into 450 training spectra and 50 testing spectra (btw, splitting is not sequential, spectra are taken randomly).</li>
%>   <li> 20-fold means 20 different training and testing datasets of 475 and 25 spectra respectively.</li>
%>   <li> 500-fold means 500 different training and testing datasets of 499 and 1 spectrum respectively, i.e., 500-fold, in this case, is equivalent to leave-one-out.</li>
%> </ul>
%>
%> <h3>References</h3>
%> Pirouette (Infometrix Inc.) Help Documentation, PCA cross-validation Section.
%>
%> @sa fcon_pca
%>

varname = input('Enter dataset variable name: ', 's');
dataset = eval([varname ';']);
dataset = data_eliminate_var0(dataset, 1e-10);
[no, nf] = size(dataset.X);
flag_kfold = input('0 - leave-one-out; 1 - k-fold cross-validation: ');
if flag_kfold
    k = input('Enter k for k-fold cross-validation: ');
else
    k = no;
end;
pc_max = input('Enter maximum number of PCs: ');


idxsmap = crossvalind('Kfold', no, k);
idxs = 1:no;
rsss = zeros(1, pc_max);

% PCA block
blk_pca = fcon_pca();

for i = 1:pc_max
    fprintf(')))))))))))\n');
    fprintf('))))))))))) Number of PCs: %d of %d\n', i, pc_max);
    
    jj = 0;
    jjj = 0;
    rss = 0; % residual sum of squares
    for j = 1:k
        idxs_test = idxs(idxsmap == k);
        idxs_train = idxs;
        idxs_train(idxs_test) = [];
        
        ds_train = dataset.map_rows(idxs_train);
        ds_test = dataset.map_rows(idxs_test);
        
        blk_pca.no_factors = i;
        blk_pca.boot();
        blk_pca = blk_pca.train(ds_train);
        
        ds_train_pca = blk_pca.use(ds_train);
        L = blk_pca.L;
        
        mm = repmat(mean(ds_train.X), length(idxs_test), 1);
        rss = rss+mean(sum((ds_test.X-(mm+(ds_test.X-mm)*L*L')).^2, 2));
        
        jj = jj+1;
        jjj = jjj+1;
        
        if jj == 10
            fprintf('))))))))))))) Crossval: %d/%d.\n', j, k);
            jj = 0;
        end;
    end;
    
    rsss(i) = rss/k;
end;


%%

figure;
plot(1:pc_max, rsss, 'k', 'LineWidth', 2);
xlabel('number of PCs');
ylabel('mean reconstruction error');
title('PCA cross-validation result');
format_frank;

fprintf('\n\nThe figure shows the\n  [number of PCs] X [mean reconstruction error (mean sum-of-squared-error)]\n  ([x] X [y])\nused.\n\nThe number of PCs to use should be\nthe one that gives the minimum y-value.\n\n');
