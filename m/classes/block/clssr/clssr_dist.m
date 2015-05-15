%> @brief Least-Distance-to-Class-Mean Classifier
%>
%> Implements the Least-Distance-to-Class-Mean Classifier ("Euclidean Distance classifier" as in [1])
%>
%> With option do weigh the points using Plamen's potential function [2].
%>
%> @sa uip_clssr_dist.m
%>
%> <h3>References</h3>
%> ﻿[1] Raudys SJ, Jain AK. Sample Size Effects in Statistical Pattern Recognition: Recommendations for Practitioners.
%%> IEEE Transactions on Pattern Analysis and Machine Intelligence. 1991;13(3).
%> 
%> [2] Angelov PP, Filev DP. An approach to online identification of Takagi-Sugeno fuzzy models. IEEE transactions on
%> systems, man, and cybernetics. Part B, Cybernetics : a publication of the IEEE Systems, Man, and Cybernetics Society.
%> 2004;34(1):484-98. Available at: http://www.ncbi.nlm.nih.gov/pubmed/15369087.
classdef clssr_dist < clssr
    properties
        normtype = 'euclidean'; % available options are: 'euclidean', (none else for the moment)
        flag_pr = 0; % Whether or not to weight the points by the potential function when calculating the per-class mean
        %> =1. Whether or not to use priors. If set, will calculate the prior class-conditional probabilities based on the amount of
        %> training data for each class.
        flag_use_priors = 1;
    end;

    properties(SetAccess=protected)
        classmeans;
        classlabels_train;
        pr_coeffs;

        % Probability of belonging to each class - calculated from training data
        priors;
    end;
        
    
    methods
        function o = clssr_dist(o)
            o.classtitle = 'Least-Distance-to-Class-Mean';
            o.short = 'Dist';
        end;
    end;
    
    methods(Access=protected)
        
        %> Calculates @c classmeans
        function o = do_train(o, data)
            o.classlabels = data.classlabels;

            t = tic; % Starts time counting

%             pieces = data_split_classes(data);
            nc = max(data.classes)+1; 
            o.classmeans = zeros(data.nf, nc);


            if ~o.flag_pr
                for i = 1:nc
                    o.classmeans(:, i) = mean(data.X(data.classes == i-1, :), 1)';
                end;
            else
                % Plamen's weighted class means where the weights are the per-class potentials
                
                A = 1; % Scaling factor for the potential formula like 1/(1+A*sum(...))
                       % This is just an internal experience

                      
               for i = 1:nc
                    Xi = data.X(data.classes == i-1, :);
                    
                    no = size(Xi, 1);

                    % Recursive calculation of beta and xi for the potential formula
                    beta = 0;
                    xi = 0;
                    for j = 1:no
                        x = Xi(j, :);
                        beta = beta+sum(x.^2);
                        xi = xi+x;
                    end;


                    % Storing these but probably won't use them.
                    o.pr_coeffs(i).beta = beta;
                    o.pr_coeffs(i).xi = xi;

                    % Again, but this time is to calculate the weighted mean
                    % mean = 1/sum(p_j)*sum(x_j*p_j)
                    sum_xp = 0;
                    sum_p = 0;
                    for j = 1:no
                        x = Xi(j, :);

                        p = no/(no*(A*x*x'+1)+A*beta-2*A*x*xi');

                        sum_xp = sum_xp+p*x;
                        sum_p = sum_p+p;
                    end;

                    o.classmeans(:, i) = sum_xp/sum_p;
                end;
            end;

            % Calculates priors
            if ~o.flag_use_priors
                o.priors = ones(1, data.nc);
            else
                for k = data.nc:-1:1 % Backwards for allocation
                    o.priors(k) = sum(data.classes == k-1);
                end;
            end;
            o.priors = o.priors/sum(o.priors);
            

            o.classlabels_train = data.classlabels;

            o.time_train = toc(t);
        end;
        

        
        %> Calculates @c est.X using the "softmax" transform, which is
        %> X(i, j) = (1/dist_of_point_i_to_class_j^2)/sum(all numerators in j)
        %>
        function est = do_use(o, data)

            est = estimato();
            est.classlabels = o.classlabels;
            est = est.copy_from_data(data);


            tic();

            nc = size(o.classmeans, 2);
            X = data.X;

            Y = zeros(data.no, nc);
            for i = 1:nc
                X_subtract = repmat(o.classmeans(:, i)', data.no, 1);
                X_ = X-X_subtract;
                Y(:, i) = 1./exp(sum(X_.^2, 2)); % distance is Euclidean
            end;
            Y(Y == Inf) = realmax();
            
            % Class posterior probabilities are weighted by their respective priors
            if o.flag_use_priors
                Y = Y.*repmat(o.priors, data.no, 1);
            end;
            
            Y = Y./repmat(sum(Y, 2), 1, nc); % normalization

            o.time_use = toc();

            est.X = Y;
%             est.classes = renumber_classes(est.classes, o.classlabels_train, o.classlabels);
        end;
    end;
end