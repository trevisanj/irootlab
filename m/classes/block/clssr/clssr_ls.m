%> @brief Least-squares classifier
%>
%>
%>
classdef clssr_ls < clssr
    properties
        %> =1. Whether or not to use priors. If set, will calculate the prior class-conditional probabilities based on the amount of
        %> training data for each class.
        flag_use_priors = 1;
        %> Whether to weight the observations (for unbalanced classes)
        flag_weighted = 0;
        %> []. Number of features. If specified, will find a threshold to trim the coefficients
        nf_select = [];
%         nregions_select = [];
    end;
    
    properties(SetAccess=protected)
        %> "Intercepts" (account for features whose mean is not zero
        intercepts;
        %> "Loadings matrix" [nf]x[nc]
        L;
        %> Recording of each stage of the feature reduction
        S;
        
    end;
        
    
    methods
        function o = clssr_ls()
            o.classtitle = 'Least-Squares';
            o.short = 'LS';
            o.flag_ui = 0;
        end;

%        %> If title is not empty, will not mess with description too much
%        function s = get_description(o)
%            if ~isempty(o.title)
%                s = get_description@clssr(o);
%            else
%                s = [get_description@clssr(o), ' type = ', o.type];
%            end;
%        end;
    end;
    
    
    methods(Static)
%         %> Thresholds L_ to have maximum nf non-zero coefficients
%         function [L_, threshs] = nfthreshold(L_, maxnf)
%             [ro, co] = size(L_);
%             
%             if maxnf >= ro
%                 %> nf maximum is less restrictive than number of existing features
%                 threshs = zeros(1, co);
%                 return;
%             end;
%             
%             for i = co:-1:1
%                 
%                 y_ = abs(L_(:, i));
%                 y = sort(y_);
%                 
%                 % Binary search
%                 ma = ro;
%                 mi = 1;
%                 while 1
%                     me = round(mean([ma, mi]));
%                     thresh = y(me);
%                     num = numel(find(y_ <= thresh));
%                     if num == ro-maxnf
%                         break;
%                     elseif num < ro-maxnf
%                         mi = me;
%                     else
%                         ma = me;
%                     end;
%                     
%                     if ma == mi
%                         break;
%                     end;
%                 end;
%                 
%                 L_(y_ <= thresh, i) = 0;
%                 threshs(i) = thresh;
%             end;
%         end;

        %> Returns weights that are inversely propoertional to the number of observations in each class
        %>
        %> Weights are scaled so that sum(w_c*N_c) = N,
        %>
        %> where w_c is the weight for class c, N_c is the number of observations in class c, and N is the total number of observations.
        function w = get_weights(data)
            ww = arrayfun(@(i) (sqrt(sum(data.classes == i))), 0:data.nc-1);
%             ww = arrayfun(@(i) (sum(data.classes == i)), 0:data.nc-1);
            w = (1./ww)*(data.no/sum(ww));
        end;
    end;
    
    methods(Access=protected)
        %{
        function o = do_train(o, data)
            o.classlabels = data.classlabels;

            t = tic();

            X = [ones(data.no, 1), data.X];
            
            if o.flag_weighted
                w = data.get_weights(1); % Calculates weights for the classes
                
                for i = 1:data.nc
                    X(data.classes == i-1, :) = X(data.classes == i-1, :)*w(i);
                end;
            end;
            
            Y = classes2boolean(data.classes);
            
            L0 = (X'*X)\(X'*Y); % Least-squares formula
            
            
            % Separates the intercept and loadings; this is for interpretability, wouldn't be needed otherwise
            o.L = L0(2:end, :);
            o.intercepts = L0(1, :);

            if ~isempty(o.nf_select) && o.nf_select > 0
                [o.L, o.thresholds] = o.nfthreshold(o.L, o.nf_select);
            end;

            
            o.time_train = toc(t);
        end;






pars.x_range = [1, 6];
pars.y_range = [3, 8];
% % %         function o = do_train(o, data)
% % %             o.classlabels = data.classlabels;
% % % 
% % %             t = tic();
% % % 
% % %             X = [ones(data.no, 1), data.X];
% % %             
% % %             if o.flag_weighted
% % %                 w = data.get_weights(1); % Calculates weighblock_mold.block_mold.ts for the classes
% % %                 
% % %                 for i = 1:data.nc
% % %                     X(data.classes == i-1, :) pars.x_range = [1, 6];
pars.y_range = [3, 8];= X(data.clasblock_mold.ses == i-1, :)*w(i);
% % %                 end;
% % %             end;
% % %             
% % %             Y = classes2boolean(data.classes);
% % %             
% % %             L0 = (X'*X)\(X'*Y); % Least-squares formula
% % %             
% % %             
% % %             % Separates the intercept and loadings; this is for interpretability, wouldn't be needed otherwise
% % %             o.L = L0(2:end, :);
% % %             o.intercepts = L0(1, :);
% % % 
% % %             if ~isempty(o.nf_select) && o.nf_select > 0
% % %                 [o.L, o.thresholds] = o.nfthreshold(o.L, o.nf_select);
% % %                 
% % %                 o.v = o.L > 0; % This is 2-class but just for a while...
% % %                 
% % %                
% % % 
% % %             
% % %             X = [ones(data.no, 1), data.X(:, o.v(:, 1))];
% % %             
% % %             if o.flag_weighted
% % %                 w = data.get_weights(1); % Calculates weights for the classes
% % %                 
% % %                 for i = 1:data.nc
% % %                     X(data.classes == i-1, :) = X(data.classes == i-1, :)*w(i);
% % %                 end;
% % %             end;
% % %             
% % %             Y = classes2boolean(data.classes);
% % %             
% % %             L0 = (X'*X)\(X'*Y); % Least-squares formula
% % %             
% % %             
% % %             % Separates the intercept and loadings; this is for interpretability, wouldn't be needed otherwise
% % %             o.L = L0(2:end, :);
% % %             o.intercepts = L0(1, :);
% % % 
% % %             
% % %             
% % %             
% % %             
% % %             
% % %             
% % %             
% % %             
% % %             
% % %             
% % %             
% % %             
% % %             end;
% % % 
% % %             
% % %             o.time_train = toc(t);
% % %         end;
% % %         

%}

        function o = do_train(o, data)
            o.classlabels = data.classlabels;
            
            o.time_train = 0;

            X0 = [ones(data.no, 1), data.X];
            if o.flag_weighted
                w = o.get_weights(data); % Calculates weights for the classes
%                 w = 
%                 w = w*data.nc*100; %/min(w);
% w = w*100;
                
                for i = 1:data.nc
                    X0(data.classes == i-1, :) = X0(data.classes == i-1, :)*w(i);
                end;
            end;
            
            Y = classes2boolean(data.classes);
            
            
            flag_reduce = ~isempty(o.nf_select);
            if ~flag_reduce
                % Much simpler stuff

                L0 = (X0'*X0)\(X0'*Y); % Least-squares formula
            else        
    
                
%                 nc = iif(data.nc == 2, 1, data.nc);
                nc = data.nc;
                
                L0 = zeros(data.nf+1, data.nc);
                
                for ic = 1:nc
                
                    vin = 1:data.nf; % Features selected

                    Sc = zeros(data.nf-o.nf_select, data.nf);
                    Yc = Y(:, ic);

            
                    for i = data.nf:-1:o.nf_select
                        X = X0(:, [1, vin+1]);

                        if i == o.nf_select
                            t = tic;
                        end;
            
%                         tt = tic();
                        L1 = (X'*X)\(X'*Yc); % Least-squares formula
%                         fprintf('%d features took %.5f seconds\n', size(X, 2), toc(tt));
                        
                        if i == o.nf_select
                            tt = toc(t);
                            fprintf('%d fea, toc toc %.6f\n', i, tt);
                            o.time_train = o.time_train+tt;
                        end;
                
                        temp = zeros(1, data.nf);
                        temp(vin) = abs(L1(2:end));
                        Sc(i-o.nf_select+1, :) = temp;

                        if i == o.nf_select
                            break;
                        end;

                        
                        [va, in] = min(abs(L1(2:end, 1)));
                        vin(in) = [];
                    end;
                    
                    
                    L0([1, vin+1], ic) = L1;
                    o.S(:, :, ic) = Sc;
                end;
                            fprintf('---Time train was %.6f seconds\n', o.time_train());                
            end;
            
            o.L = L0(2:end, :);
            o.intercepts = L0(1, :);

            
        end;
        

%{
        %> With bits from MATLAB classify()
        function est = do_use(o, data)
            est = estimato();
            est.classlabels = o.classlabels;
            est = est.copy_from_data(data);

            t = tic();

            X = data.X(:, o.v); % Temporary
            
            
            X = [ones(data.no, 1), X];
            posteriors = X*[o.intercepts; o.L];
            posteriors = normalize_rows(posteriors);
                    
            est.X = posteriors;
            o.time_use = toc(t);
        end;
%}

        
        function est = do_use(o, data)
            est = estimato();
            est.classlabels = o.classlabels;
            est = est.copy_from_data(data);

            t = tic();

            X = [ones(data.no, 1), data.X];
            posteriors = X*[o.intercepts; o.L];
%             posteriors = normalize_rows(posteriors);
%             posteriors = irsoftmax(posteriors);
%             posteriors = exp(exp(exp(exp(posteriors))));
            posteriors = normalize_rows(exp(posteriors).^2);
%             posteriors = normalize_rows(posteriors);
%             posteriors = round(posteriors);
                    
            est.X = posteriors;
%             est.X = round(est.X);
            o.time_use = toc(t);
        end;




    end;


end