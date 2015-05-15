%> @brief Records (test class)x([rejected, estimation class]) hits
classdef estlog_classxclass < estlog
    properties
        %> All possible class labels in reference datasets
        testlabels = {};
        %> All possible class labels in estimation datasets
        estlabels = {};
        %> =0. What to give as a "rate". 0-mean sensitivity; 1-diagonal element defined by idx_rate
        ratemode = 0;
        %> =1. Diagonal element if @c ratemode is 1.
        idx_rate = 1;
    end;
    
    methods
        function o = estlog_classxclass()
            o.classtitle = 'Class X Class';
            o.flag_sensspec = 1;
            o.flag_params = 1;
        end;
    end;
    
    methods(Access=protected)
        %> Returns the contents of the @c estlabels property.
        function z = get_collabels(o)
            z = o.estlabels;
        end;
        
        %> Returns the contents of the @c testlabels property.
        function z = get_rowlabels(o)
            z = o.testlabels;
        end;

        function o = do_record(o, pars)
            est = pars.est;
            ds_test = pars.ds_test;
            if isempty(est.classes)
                irerror('Classes of estimation dataset are empty! Are you sure it has been put through a decider?');
            end;
            if numel(est.classes) ~= numel(ds_test.classes)
                irerror('Number of items in estimation is different from number of items in reference dataset!');
            end;
            estclasses = renumber_classes(est.classes, est.classlabels, o.estlabels);
            for i = 1:numel(o.testlabels)
                classidx = find(strcmp(o.testlabels{i}, ds_test.classlabels)); % rowlabel of turn class index in reference dataset
                if isempty(classidx)
                    % Class was not tested <--> not present in reference (test) dataset
                else
                    rowidxs = ds_test.classes == classidx-1; % Indexes of rows belonging to i-th class
                    sel = estclasses(rowidxs);
                    if o.flag_support
                        supp = est.X(rowidxs, 1)';
                    end;
                    
   
%                     % Method 1: better with more classes; better with less rows
%                     x = sort(sel);
%                     difference = diff([x;max(x)+1]); 
%                     count = diff(find([1;difference]));
%                     y = x(find(difference)); 
                    
                    % Method 2: better with fewer classes; better with more rows
                    % Both methods are quite quick anyway
                    for j = 1:numel(o.estlabels)
                        idxidxbool = sel == j-1;
                        o.hits(i, j+1, o.t) = o.hits(i, j+1, o.t)+sum(idxidxbool);
                        if o.flag_support
                            o.supports{i, j+1, o.t} = supp(idxidxbool); % Assumeed that est is the output of a decider block which produces a X with one feature only, which is the support.
                        end;
                    end;
                    
                    idxidxbool = sel == -1;
                    o.hits(i, 1, o.t) = sum(idxidxbool); % Rejection count.
                    if o.flag_support
                        o.supports{i, 1, o.t} = supp(idxidxbool); % Assumeed that est is the output of a decider block which produces a X with one feature only, which is the support.
                    end;
                end;
            end;
        end;
    end;

    methods
        %> Returns average of diagonal of confusion matrix.
        %>
        %> If one row wasn't tested, it won't enter the average calculation
        function z = get_meandiag(o)
            C = o.get_C([], 1, 3, 1);
            W = o.get_weights([], 1); % (no_rows)x(no_t) matrix of weights
            w = sum(W, 2) > 0;
            z = diag(C(:, 2:end))'*w/sum(w(:)); % Re-normalizes using weights for every element of the diagonal
        end;
        
        %> Either redirects to get_meandiag() or returns diagonal element of average confusion matrix
        function z = get_rate(o)
            if o.ratemode == 0
                z = o.get_meandiag();
            else
                C = o.get_C([], 1, 3, 1);  % Gets average percentage with discounted rejected items
                z = C(o.idx_rate, o.idx_rate+1);
            end;
        end;
        
        %> Returns vector with time-wise-calculated averages
        %>
        %> @return If @c ratemode == 0, returns the average of the diagonal calculated for each time instant, weighted by
        %> whether each row was tested or not; if @c ratemode > 0, returns one diagonal element for each time instant. In either case, rejected
        %> items are discounted.
        function z = get_rates(o)
            CC = o.get_C([], 1, 0, 1); % gets per-time matrices of percentages
            if o.ratemode > 0
                z(:) = CC(o.idx_rate, o.idx_rate+1, :);
            else
                W = o.get_weights([], 1); % (no_rows)x(no_t) matrix of weights
                n = size(CC, 3);
                z = zeros(1, n);
                for i = 1:n
                    z(i) = diag(CC(:, 2:end, i))'*W(:, i); % dot product
                end;
            end;
        end;
    end;    
end
