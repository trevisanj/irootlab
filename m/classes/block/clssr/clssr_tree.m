%> @brief Binary Decision Tree Classifier
%>
%> @sa uip_clssr_tree.m, demo_clssr_tree.m
classdef clssr_tree < clssr
    properties
        %> @c =fsgt_infgain(). FSGT object to obtain the feature to be used at each node.
        fsgt = fsgt_infgain();
        %> =1 . Pruning type: 0 - no pruning; 1 - maximum number of levels; 2 - backward pruning; 3 - Quinan's chi-squared test
        pruningtype = 1;
        %> =10 . Maximum number of levels. The number of nodes is 2^(numberOfLevels)-1
        no_levels_max = 5;
        %> Chi-squared test threshold for @c pruningtype = 3. 0 - no pruning; 10 - heavy pruning
        chi2threshold = 3;
    end;
    
    properties(SetAccess=protected)
        %> Structure with the following fields:
        %> @arg feaidx
        %> @arg probs
        %> @arg flag_leaf
        %> @arg idx_left
        %> @arg idx_right
        %> @arg occur
        %> @arg occur0
        %> @arg threshold
        nodes;
    end;

    methods
        function o = clssr_tree(o)
            o.classtitle = 'Binary Decision Tree';
            o.short = 'BTree';
        end;
        
%        function s = get_description(o)
%            no_leaves = 0;
%            if ~isempty(o.nodes)
%                no_leaves = sum([o.nodes.flag_leaf]);
%            end;
%            s = [get_description@clssr(o), '; number of leaves: ', int2str(no_leaves)];
%        end;
        
        
        function o = prune(o)
            % Not sure, as I have so many features. Am I really going to grow this shit till the end???
        end;

        
        
        
        function s = get_treedescription(o)
            nind = 0;
            ptr = 1;
            s = o.get_treedescription_(ptr, nind);
        end;
        
    end;
    
    methods(Access=protected)
        function s = get_treedescription_(o, ptr, nind)
            s = '';
            node = o.nodes(ptr);
            if node.flag_leaf
                [vv, ii] = max(node.probs);
                s = [s, 10, 32*ones(1, nind*4), sprintf('class %s (%d: %g%%)', o.classlabels{ii}, node.occur0(ii), vv*100)];
            else
                s = [s, 10, 32*ones(1, nind*4), sprintf('if fea%d <= %g', node.feaidx, node.threshold)];
                s = [s, o.get_treedescription_(node.idx_left, nind+1)];
                s = [s, 10, 32*ones(1, nind*4), 'else'];
                s = [s, o.get_treedescription_(node.idx_right, nind+1)];
            end;
        end;
            

        function [out, idxptr, no_leaves] = make_tree(o, X, classes, nc, idxptr, no_leaves, level)
            node = struct('feaidx', {[]}, 'probs', {[]}, 'flag_leaf', {0}, 'idx_left', {[]}, 'idx_right', {[]}, 'occur', {[]}, 'occur0', {[]}, 'threshold', {0});


%             if numel(classes) == 0
%                 disp('Viche nego, fudeu alguma coisa');
%             end;
            
            
            flag_leaf = all(classes == classes(1)) || ... % All observations have same class
                          (o.pruningtype == 1 && level >= o.no_levels_max);
%                         (o.pruningtype == 1 && no_leaves >= o.maxleaves-1); % Reached maximum number of leaves


            
            idxs = 1:size(X, 2); % This is gonna change at some point
            
            if ~flag_leaf
                [grades, idx, threshold] = o.fsgt.test(X, classes);

                if isempty(threshold)
                    flag_leaf = 1;
%                 elseif o.pruningtype == 1 && idxptr > o.maxleaves
                elseif o.pruningtype == 2
                    % hypothesis test criterion
                    irerror('Hypothesis test criterion not implemented yet!');
                elseif o.pruningtype == 3
                    chi2 = o.quinlantest(X(:, idx), classes, threshold);
                    if chi2 <= o.chi2threshold
                        flag_leaf = 1;
                    end;
                end

                if ~flag_leaf
                    % Splits datasets for the branches
                    ii1 = X(:, idxs(idx)) <= threshold;
                    ii2 = X(:, idxs(idx)) > threshold;
                    
                    if sum(ii1) == 0 || sum(ii2) == 0
                        % For some reason, the FSGT test may yield a threshold that completely isolates the points into one side ...
                        % This is happening very rarely
                        flag_leaf = 1;
                    else
                        node.flag_leaf = 0;
                        node.threshold = threshold;
                        node.feaidx = idxs(idx);
                        [node.probs, node.occur0] = get_probs(classes, nc); % Gets per-class probabilities based on number of occurences for each class

                        idxptr = idxptr+1;
                        node.idx_left = idxptr;
                        [tree_left, idxptr, no_leaves] = o.make_tree(X(ii1, :), classes(ii1), nc, idxptr, no_leaves, level+1); % Left branch

                        node.idx_right = idxptr;
                        [tree_right, idxptr, no_leaves] = o.make_tree(X(ii2, :), classes(ii2), nc, idxptr, no_leaves, level+1); % Right branch

                        out = [node, tree_left, tree_right];
                    end;
                end;
            end

            if flag_leaf
                [node.probs, node.occur0] = get_probs(classes, nc);
                node.flag_leaf = 1;
                out = node;
                idxptr = idxptr+1;
                no_leaves = no_leaves+1;
            end;
        end;


        %> Quinlan's Chi-square test for early stopping
        %>
        %> 
        %> Computes the Chi-square test described by Quinlan [1].
        %>
        %> [1] J.R. Quinlan, Simplifying Decision Trees, 
        %> Int. J. Man - Machine Studies, vol. 27, 1987, pp. 221-234.
        %> 
        %> Credits:
        %>
        %> Guido te Brake, TWI/SSOR, TU Delft.
        %> Copyright: R.P.W. Duin, duin@ph.tn.tudelft.nl
        %> Faculty of Applied Physics, Delft University of Technology
        %> P.O. Box 5046, 2600 GA Delft, The Netherlands

        function xi2 = quinlantest(o, Xj, classes, threshold)
            m = numel(Xj);
            ELAB = classes2boolean(classes);
            L = sum(ELAB(Xj <= threshold,:),1) + 0.001;
            R = sum(ELAB(Xj > threshold,:),1) + 0.001;
            LL = (L+R) * sum(L) / m;
            RR = (L+R) * sum(R) / m;
            xi2 = sum(((L-LL).^2)./LL + ((R-RR).^2)./RR);
        end;

        
        
        
        function o = do_train(o, data)
            o.classlabels = data.classlabels;
            tic;
            [o.nodes, dummy1, dummy2] = o.make_tree(data.X, data.classes, data.nc, 1, 0, 1);
            o.time_train = toc;
        end;
        
        
        %> Number of occurences per class are registered at each node
        function est = do_use(o, data)
            est = estimato();
            est.classlabels = o.classlabels;
            est = est.copy_from_data(data);

            t = tic();
            est.X = zeros(data.no, numel(o.classlabels));


            classes = renumber_classes(data.classes, data.classlabels, o.classlabels);
            boolclasses = classes2boolean(classes, numel(o.classlabels));
            flag_record_occurences = ~isempty(boolclasses);
            obsnodes = ones(data.no, 1);
            for i = 1:numel(o.nodes)
                ii = find(obsnodes == i); 
                if flag_record_occurences
                    o.nodes(i).occur = sum(boolclasses(ii,:));
                end
                if ~o.nodes(i).flag_leaf
                    ii_left = ii(data.X(ii, o.nodes(i).feaidx) <= o.nodes(i).threshold);
                    ii_right = ii(data.X(ii,o.nodes(i).feaidx) > o.nodes(i).threshold);
                    obsnodes(ii_left) = o.nodes(i).idx_left*ones(1,length(ii_left));
                    obsnodes(ii_right) = o.nodes(i).idx_right*ones(1,length(ii_right));
                else
                    obsnodes(ii) = inf * ones(1,length(ii));
                    est.X(ii, :) = repmat(o.nodes(i).probs, numel(ii), 1);
                end;
            end;
            
            o.time_use = toc(t);
        end;
   
        
        
        
        %> 
        function s = do_get_report(o)
            s = [get_matlab_output(o), 10, o.get_treedescription()];
        end;
        
        
        

        function o = do_draw_domain(o, params)
            
            do_draw_domain@clssr(o, params);
            
            if ~isempty(o.nodes)
                o.draw_lines(1, params.x_range, params.y_range);
            end;
        end;

        function o = draw_lines(o, nodeidx, x_range, y_range)
            node = o.nodes(nodeidx);
            if ~node.flag_leaf
                if node.feaidx == 1
                    xx = [1, 1]*node.threshold;
                    yy = y_range;
                    o.draw_lines(node.idx_left, [x_range(1), node.threshold], y_range);
                    o.draw_lines(node.idx_right, [node.threshold, x_range(2)], y_range);
                else
                    xx = x_range;
                    yy = [1, 1]*node.threshold;
                    o.draw_lines(node.idx_left, x_range, [y_range(1), node.threshold]);
                    o.draw_lines(node.idx_right, x_range, [node.threshold, y_range(2)]);
                end;
                plot3(xx, yy, [2, 2], 'k', 'LineWidth', 2);
            end;
        end;

    end;
end