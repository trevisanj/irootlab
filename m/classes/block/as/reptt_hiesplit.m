%> @brief Hierarchical split 
%>
%> Feeds blocks with successive sub-datasets obtaining by splitting @c data using the @c hie_split class levels
%>
%> @attention
%> The classifiers in the @c clssrs property must be multi-trainable (recommended: @ref aggr_free).
%> The classifiers must <b>not</b> be of class @c aggr_hiesplit.
%>
%> @todo Temporaritly deactivated. This may be obsolete. There is new dataset property instead of this hie_split/hie_classify pair
%>
%> @sa uip_reptt_hiesplit.m, demo_reptt_hiesplit.m
classdef reptt_hiesplit < reptt
    properties
        %> Number of repetitions. Each repetition corresponds to a random permutation of the order with which the
        %> sub-datasets are given to the classifier.
        no_reps = 10;
        %> =1 . Class levels to use at splitting the dataset
        hie_split = 1;
        %> =2 . Class levels to use at selecting the relevant classes for classification
        hie_classify = 2;
        %> if > 0, MATLAB's rand('twister', o.randseed) will be called before. This can be used to repeat sequences.
        randomseed = 0;
        %> Test dataset
        data_test;
    end;
    
    properties(Access=protected)
        pieces;
        pvt_data_test;
    end;
    methods
        function o = reptt_hiesplit(o)
            o.classtitle = 'Class-Hierarchical Split';
%            o.moreactions = {'go', 'extract_logs', 'extract_curves'};
            o.flag_ui = 0;
        end;
    end;
%{    
    methods (Access=protected)
        %> Allocates cell of logs (no_logs)X(no_blocks)X(no_reps) allocated with no_pieces slots
        function o = allocate_logs(o)
            if ~iscell(o.log_mold)
                mold = {o.log_mold};
            else
                mold = o.log_mold;
            end;
            if ~iscell(o.block_mold)
                bmold = {o.block_mold};
            else
                bmold = o.block_mold;
            end;

            no_logs = numel(mold);
            no_blocks = numel(o.blocks);
            o.logs = cell(no_logs, no_blocks, o.no_reps);
            for i = 1:no_logs
                for j = 1:no_blocks
                    for k = 1:o.no_reps
                        o.logs{i, j, k} = mold{i}.allocate(numel(o.pieces));
                        o.logs{i, j, k}.title = ['From classifier ', bmold{j}.get_description()];
                    end;
                end;
            end;
        end;
        
        %> Allocates cell of blocks (1)X(no_blocks)
        function o = allocate_blocks(o)
            if ~iscell(o.block_mold)
                mold = {o.block_mold};
            else
                mold = o.block_mold;
            end;
            no_blocks = numel(mold);
            o.blocks = cell(1, no_blocks);
            for i = 1:no_blocks
                o.blocks{i} = mold{i}.boot();
            end;
        end;
    end;
    

    methods
        function o = go(o)
            o = o.boot_postpr(); % from reptt

            if o.randomseed > 0
                s = RandStream.getDefaultStream; % Random stream used in random functions (default one).
                save_State = s.State; % Saves state to restore later.
                reset(s, o.randomseed); % Resets state to one made from o.randomseed
            end;

            o.pieces = data_split_classes(o.data, o.hie_split);
            np = numel(o.pieces);
            for i = 1:np % Not sure about the future of aggr_hiesplit
                o.pieces(i) = data_select_hierarchy(o.pieces(i), o.hie_classify);
            end;

            o = o.allocate_blocks();

            o = o.allocate_logs();

            % Only needs to do it once
            if ~isempty(o.postpr_test)
                o.pvt_data_test = o.postpr_test.use(data_select_hierarchy(o.data_test, o.hie_classify));
            else
                o.pvt_data_test = data_select_hierarchy(o.data_test, o.hie_classify);
            end;

            [nl, nb, nr] = size(o.logs);
            
            ipro = progress2_open('REPTT_HIESPLIT', [], 0, o.no_reps);
            for i_rep = 1:o.no_reps
                seq = randperm(np);
                for i = 1:nb
                    bl = o.blocks{i}.boot();

                    for k = 1:np
                        bl = bl.train(o.pieces(seq(k)));

                        est = bl.use(o.pvt_data_test);

                        if ~isempty(o.postpr_est)
                            est = o.postpr_est.use(est);
                        end;
                        
                        if isempty(est.classes)
                            irerror('Estimation post-processing did not assign classes!');
                        end;

                        pars = struct('est', {est}, 'ds_test', {o.pvt_data_test}, 'clssr', {bl});
                        for j = 1:nl
                            o.logs{j, i, i_rep} = o.logs{j, i, i_rep}.record(pars);
                        end;
                    end;
                end;
                ipro = progress2_change(ipro, [], [], i_rep);
            end;
            progress2_close(ipro);
            
            if o.randomseed > 0
                set(s, 'State', save_State); % Restores default stream state so that random numbers can be generated as if nothing really happened here.
            end;
        end;
        
        
        % Extract evolution curves from logs. Returns a cell matrix of @c irdata objects
        function out = extract_curves(o)
            [nl, nb, nr] = size(o.logs);
            np = numel(o.pieces);
            out = cell(nl, nb);
            
            for i = 1:nl
                for j = 1:nb
                    d = irdata();
                    d.fea_x = 1:np;
                    d.title = sprintf('LOG %s; BLOCK %s', o.logs{i, j, 1}.get_description(), o.blocks{j}.get_description());
                    d.X = zeros(nr, np);
                    d.xname = 'Number of datasets added';
                    d.xunit = '';

                    for k = 1:nr
                        % Yeah, get_rates() returns one curve
                        d.X(k, :) = o.logs{i, j, k}.get_rates();
                    end;
                    
                    out{i, j} = d;
                end;
            end;
        end;
    end;
%}    
end
