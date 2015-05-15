%> @brief (dataset %) x (classification rate) curve
%>
%> @ingroup as needsrevision
%>
%> Runs a repeated sub-sampling loop for a given percentual with recording each generated @ref ttlog. Then,
%> Increases this percentual, runs the cross-validation loop again, and so on.
%>
%> @sa uip_dsperc_x_rate.m
classdef as_dsperc_x_rate < as
    properties
        %> reptt_blockcube object to do the evaluation
        %> Note that only the first element of evaluator's @c log_mold will have effect. The others will be reset (if any).
        evaluator;
        %> =.1:.1:.9. Sequence of percentages for training
        percs_train = .1:.1:.9;;
        %> = .1. Percentage for testing. Note that <code>prect_test + percs_train(end)</code> should not exceed 1 (100%)
        perc_test = .1;

    end;

    methods
        function o = as_dsperc_x_rate(o)
            o.classtitle = '(dataset%)x(performance) curve';
            o.flag_ui = 0; % Not published in GUI
        end;
    end;
    
    methods(Access=protected)
        function log = do_use(o, data)
            if ~isa(o.evaluator, 'reptt_blockcube')
                irerror('Evaluator must be a reptt_blockcube!');
            end;
            if ~isa(o.evaluator.sgs, 'sgs_randsub')
                irerror('Evaluator''s SGS must be a sgs_randsub!');
            end;
            if strcmp(o.evaluator.sgs.type, 'fixed')
                irerror('Evaluator''s SGS''s type cannot be ''fixed''!');
            end;
            
            o.evaluator.log_mold = o.evaluator.log_mold(1); % Resets evaluator's log_mold to its first element.
        
            npercs = numel(o.percs_train);
            nclssr = numel(o.evaluator.block_mold);

            log = log_celldata();
            log.celldata = cell(nclssr, npercs);
            
            for iperc = 1:npercs
                o.evaluator.sgs.bites = [o.percs_train(iperc), o.perc_test];
                log_cube = o.evaluator.use(data);
                log.celldata(:, iperc) = cellfun(@(x) (x.get_rates()), log_cube.logs, 'UniformOutput', 0);
            end;
            
            log.fea_x = o.percs_train*100;
            log.xname = 'Percent of dataset used in training';
            log.xunit = '%';
            log.yname = 'Classification rate';
            log.yunit = '%';
            log.rownames = cellfun(@(x) x.get_description(), o.evaluator.block_mold(:)', 'UniformOutput', 0);
        end;
    end;
end
