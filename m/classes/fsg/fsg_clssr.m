%>@brief FSG that uses classifier to grade the subsets
%>
%> The grades are classification rates expressed in percentages (from 0 to 100)
%>
%> If not using SGS, must assign a 2-dataset vector to @ref data
%>
%> @sa uip_fsg_clssr.m, reptt
classdef fsg_clssr < fsg
    properties
        clssr;
        estlog;
        %> (Optional) Block to post-process the test data. For example, a @ref grag_classes_first.
        postpr_test;
        %> Block to post-process the estimation issued by the classifier. Examples:
        %> @arg a @ref decider
        %> @arg a @block_cascade_base consisting of a @ref decider followed by a @ref grag_classes_vote
        postpr_est;
    end;
    
    methods
        function s = get_yname(o)
            s = o.estlog.get_legend();
        end;
        function s = get_yunit(o)
            s = o.estlog.get_unit();
        end;
    end;
    
    methods(Access=protected)
        %> Cross-validation is performed here.
        %> return a (no_pairs)x(no_idxs)x(no_test_sets) grades vector
        function z = do_calculate_pairgrades(o, idxs)
            if ~o.flag_sgs
                [npair, ntt] = size(o.datasets); % number of pairs, number of sub-datasets
                nidx = numel(idxs);
                z = zeros(npair, nidx);
                for ipair = 1:npair % Pairwise LOOP
                    for itt = ntt:-1:1 % Backwards to pre-allocate
                        train_test(:, itt) = o.datasets(ipair, itt).select_features(idxs)';
                    end;

                    for iidx = nidx:-1:1
%                         t = tic();
                        cl = o.clssr.boot();
                        cl = cl.train(train_test(iidx, 1));
                        for k = 2:ntt
                            
                            est = cl.use(train_test(iidx, k));
                            est = o.postpr_est.use(est);

                            if ~isempty(o.postpr_test)
                                ds_test = o.postpr_test.use(train_test(iidx, k));
                            else
                                ds_test = train_test(iidx, k);
                            end;

                            pars = struct('est', {est}, 'ds_test', {ds_test}, 'clssr', {cl});

                            lo = o.estlog.allocate(1);
                            lo = lo.record(pars);
                            z(ipair, iidx, k-1) = lo.get_rate();
                        end;
                    end;
                end;
            else
                npair = numel(o.subddd);
                [nreps, ntt] = size(o.subddd{1});
                nidx = numel(idxs);
                z = zeros(npair, nidx);
                for ipair = 1:npair % Pairwise LOOP
                    dd = o.subddd{ipair};

                    for k = ntt:-1:1
                        for irep = nreps:-1:1
                            dnows(irep, k, :) = dd(irep, k).select_features(idxs);
                        end;
                    end;

                    for iidx = 1:nidx % Feature Subset LOOP
                        % Allocates one log per test set
                        for k = ntt:-1:2
                            lo(k-1) = o.estlog.allocate(nreps);
                        end;

                        for irep = 1:nreps % Cross-validation loop
                            cl = o.clssr.boot();
                            cl = cl.train(dnows(irep, 1, iidx));
                            
                            for k = 2:ntt
                                est = cl.use(dnows(irep, k, iidx));
                                est = o.postpr_est.use(est);

                                if ~isempty(o.postpr_test)
                                    ds_test = o.postpr_test.use(dnow(k));
                                else
                                    ds_test = dnows(irep, k, iidx);
                                end;

                                pars = struct('est', {est}, 'ds_test', {ds_test}, 'clssr', {cl});
                                lo(k-1) = lo(k-1).record(pars);
                            end;
                        end;

                        for k = 2:ntt
                            z(ipair, iidx, k-1) = lo(k-1).get_rate();
                        end;
                    end;
                end;
            end;
        end;
    end;
    
    methods
    
        %> Couple of checks
        %>
        %> @arg Makes sure that @ref postpr_est is able to decide
        %> Checks datasets
        function o = boot(o)
            if isempty(o.postpr_est)
                irverbose('fsg_clssr is creating default postpr_est decider', 1);
                o.postpr_est = decider();
            end;
            
            if isempty(o.estlog)
                irverbose('fsg_clssr is creating default estlog estlog_classxclass', 1);
                z = estlog_classxclass();
                z.estlabels = o.datasets(1, 1).classlabels;
                z.testlabels = z.estlabels;
                o.estlog = z;
            end;
            
            % Checks if postpr_est is ok; boots the post-processors
            if ~isempty(o.postpr_est)
                o.postpr_est = o.postpr_est.boot();
            end;
            if ~isempty(o.postpr_test)
                o.postpr_test = o.postpr_test.boot();
            end;

            
            assert_decider(o.postpr_est);
            
            
            % Checks whether the sgs property is set, or else if the datasets property has two columns
            if isempty(o.sgs) && size(o.datasets, 2) < 2
                irerror('If sgs is not set, the data property must receive two datasets (train-test)!');
            end;
            
            o = boot@fsg(o);
        end;

        function o = fsg_clssr()
            o.classtitle = 'using Classifier';
        end;
    end;
end
