%> @brief "Rater" class
%>
%> This class makes simple the job evaluating a classifier performance through cross-validation. It fills in all
%> properties with default values, except from @c data:
%> @arg Default postpr_est
%> @arg Default postpr_test
%> @arg Default sgs
%> @arg Default ttlog
%> @arg Even default classifier
%>
%> A more complex (but complete) alternative is @ref reptt_blockcube
%>
%> @sa uip_rater.m, demo_rater.m
classdef rater < as
    properties
        clssr;
        %> (Optional). If two datasets are passed, a SGS is not created, but the datasets are used instead for a single train-test
        sgs;
        %> (Optional) Block to post-process the test data.
        postpr_test;
        %> Block to post-process the estimation issued by the classifier.
        postpr_est;
        ttlog;
    end;
    
    properties(SetAccess=protected)
        flag_sgs;
    end;
    

    methods
        function o = rater()
            o.classtitle = 'Rater';
        end;
    end;
    
    methods(Access=protected)
        %> Returns the object with its ttlog ready to have its get_rate() called.
        function log = do_use(o, data)
            o = o.check(data);
            
            if o.flag_sgs
                obsidxs = o.sgs.get_obsidxs(data);
                datasets = data.split_map(obsidxs(:, [1, 2]));

                no_reps = size(obsidxs, 1);
            
                log = o.ttlog.allocate(no_reps);
                ipro = progress2_open('RATER', [], 0, no_reps);
                for i = 1:no_reps
                    log = traintest(log, o.clssr, datasets(i, 1), datasets(i, 2), o.postpr_test, o.postpr_est);
                    ipro = progress2_change(ipro, [], [], i);
                end;
                progress2_close(ipro);
            else
                log = o.ttlog.allocate(1);
                log = traintest(log, o.clssr, data(1), data(2), o.postpr_test, o.postpr_est);
            end;
        end;
        
        function z = get_rate(o)
            o = o.go();
            z = o.ttlog.get_rate();
        end;
        
        function z = get_rate_with_clssr(o, x)
            o.clssr = x;
            log = o.go();
            z = log.get_rate();
        end;

        function o = check(o, data)
            o.clssr = def_clssr(o.clssr);
            if isempty(o.postpr_est)
                o.postpr_est = def_postpr_est();
                o.postpr_test = def_postpr_test(); % Overrides pospr_test because need a harmonic pair
            end;

            o.flag_sgs = 1;
            if isempty(o.sgs) 
                if numel(data) == 1
                    irverbose('Rater is creating default SGS', 2);
                    o.sgs = def_sgs();
                else
                    o.flag_sgs = 0;
                end;
            end;
            
            if isempty(o.ttlog)
                irverbose('Rater is creating default ttlog estlog_classxclass', 2);
                z = estlog_classxclass();
                z.estlabels = data(1).classlabels;
                z.testlabels = z.estlabels;
                o.ttlog = z;
            end;
        end;
    end;
end
