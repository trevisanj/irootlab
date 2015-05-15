%> @brief Base class for Incremental Classifiers
%>
%> These classifiers have a learning process that uses one data row at a time.
%>
%> This class introduced facilities to record the "learning curve" (evolution of the classifier performance as it learns) of the classifier.
%>
%> @note If the classifier is set to record, (i.e., flag_rtrecord is true), it can only be trained once
%>
%>
classdef clssr_incr < clssr
    properties
        %> =0. Whether to attempt to record the learning curve in RealTime (RT)
        flag_rtrecord = 0;
        %> =1. Recording periodicity
        record_every = 1;
        
        %> (Optional) Block to post-process the test data. For example, a @ref grag_classes_first.
        postpr_test;
        %> Block to post-process the estimation issued by the classifier. Examples:
        %> @arg a @ref decider
        %> @arg a @block_cascade_base consisting of a @ref decider followed by a @ref grag_classes_vote
        postpr_est;
        
        %> Test dataset, to be used only if @ref flag_rtrecord is true
        data_test;
        
        %> Cell of @ref ttlog objects
        log_mold;
    end;
    
    properties (SetAccess=protected)
        %> (number of elements in log_mold)x(number of elements in training set (see also @ref clssr_incr::allocate()).
        %> Learning curves recorded here
        rates;
        %> Recording index
        i_r;
        %> Restarting counter to know when to record (see @ref every)
        i_e;
        %> Number of allocated recordings
        nar;
        %> Number of rows in the training set
        no_rows;
        %> Row index, incremented when record() is called
        i_row;
        %> Whether recording has been allocated
        flag_allocated = 0;
    end;
    
    methods
        function o = clssr_incr()
            o.classtitle = 'Incremental';
        end;
    end;
    
    methods(Access=protected)
        function o = do_boot(o)
            if o.flag_rtrecord
                % Checks if postpr_est is ok; boots the post-processors
                if ~isempty(o.postpr_est)
                    o.postpr_est = o.postpr_est.boot();
                end;
                if ~isempty(o.postpr_test)
                    o.postpr_test = o.postpr_test.boot();
                end;

                assert_decider(o.postpr_est);

                o.i_r = 0;
                o.i_e = 1;
                
                o.flag_allocated = 0;
            end;
            
            o = do_boot@clssr(o);
        end;

        %> Records one column of @ref clssr_incr::rates
        function o = record(o)
            if ~o.flag_allocated
                o = o.allocate(o.no);
            end;
            
            o.i_row = o.i_row+1;
            if o.i_row == o.no_rows || o.i_e >= o.record_every
                o.i_e = 1;
            
                o.i_r = o.i_r+1;
                
                if o.i_r > o.nar
                    irerror(sprintf('Number of allocated recordings is only %d, but wanted to record element # %d!', o.nar, o.i_r));
                end;

                est = o.use(o.data_test);

                if ~isempty(o.postpr_est)
                    est = o.postpr_est.use(est);
                end;
                if isempty(est.classes)
                    irerror('Estimation post-processing did not assign classes!');
                end;

                if ~isempty(o.postpr_test)
                    ds_test = o.postpr_test.use(o.data_test);
                else
                    ds_test = o.data_test;
                end;

                pars = struct('est', {est}, 'ds_test', {ds_test}, 'clssr', {o});

                for i = 1:numel(o.log_mold)
                    log = o.log_mold{i}.allocate(1);
                    log = log.record(pars);
                    o.rates(i, o.i_r) = log.get_rate();
                end;
            else
                o.i_e = o.i_e+1;
            end;
        end;
            
        %> Allocates the @ref clssr_incr::rates property
        %>
        %> Called every time train() is called
        function o = allocate(o, n)
            o.no_rows = n;
            o.i_row = 0;
            o.nar = o.get_no_recordings(n);
            o.rates = zeros(numel(o.log_mold), o.nar);
            o.flag_allocated = 1;
        end;

    end;
    
    methods

        %> Returns number of recordings based on internal setup
        %>
        %> returns <code>ceil(n/o.record_every)</code>
        function nr = get_no_recordings(o, n)
            nr = ceil(n/o.record_every);
        end;
    end;
end