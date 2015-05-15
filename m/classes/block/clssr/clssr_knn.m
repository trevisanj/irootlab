%> @brief k-Nearest Neighbours Classifier
%>
%> Posterior probabilities are calculated using the Laplace estimator [1].
%>
%> <h3>References</h3>
%> [1] Kuncheva, Combining Pattern Classifiers, page 154, 2004.
%>
%> @sa uip_clssr_knn.m
classdef clssr_knn < clssr
    properties
        %> =1. k-NN's k.
        k = 1;
    end;
    
    properties(SetAccess=private)
        %> Training data is part of the model in the k-NN algorithm
        X = []; 
        classes = [];
    end;

    methods
        function o = clssr_knn(o)
            o.classtitle = 'k-Nearest Neighbours';
            o.short = 'k-NN';
        end;
    end;
    
    methods(Access=protected)
        
        function o = do_boot(o)
        end;
        
        function o = do_train(o, data)
            o.classlabels = data.classlabels;

            tic;
            o.X = data.X;
            o.classes = o.get_classes(data);
            o.time_train = toc;
        end;
        
        
        
        %> Uses Laplace estimator for the posterior probabilities
        %>
        %> Reference: Kuncheva, Combining Pattern Classifiers, page 154, 2004.
        function est = do_use(o, data)
            flag_verbose = 1;
            no_obs_test = data.no;
            no_obs_train = size(o.X, 1);
            no_classes = length(o.classlabels);

            votes = zeros(no_obs_test, no_classes);
            est = estimato();
            est.classlabels = o.classlabels;
            est = est.copy_from_data(data);

            ii = 0;
            tic();
            for i = 1:no_obs_test
                % vector to be tested
                v_test = data.X(i, :);

                % Distance vector
                dists = sum(bsxfun(@minus, o.X, v_test).^2, 2);

                [vv, idxs] = sort(dists);

                for j = 1:min(no_obs_train, o.k)
                    votes(i, o.classes(idxs(j))+1) = votes(i, o.classes(idxs(j))+1)+1;  % Here a weight on the vote could be put 
                end;
                
                if flag_verbose
                    ii = ii+1;
                    if ii == 1000
                        ii = 0;
                        irverbose(sprintf('%d/%d', i, no_obs_test));
                    end;
                end;
            end;

            est.X = (votes+1)/(no_classes+o.k); % The Laplace formula

            o.time_use = toc();
        end;
    end;

end