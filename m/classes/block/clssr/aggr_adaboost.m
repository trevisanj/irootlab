%> @brief Adaboost
%>
%> @todo is there a way to make this testable as classifiers are added?
%>
%> Reference: Kuncheva, I. "Combining Patten Classifiers", Wiley, 2004.
%>
%> @sa uip_aggr_adaboost.m
classdef aggr_adaboost < aggr
    properties
        %> must contain a block object that will be replicated as needed
        block_mold = [];
        %> This SGS needs be a of class @c sgs_weighted
        sgs;
        %> Number of classifiers to be generated
        no_clssrs = 10;
        %> Coefficient to multiply weights by for misclassified samples
    end;
    
    properties(SetAccess=protected)
        % Weight updating coefficients per iteration
        betas;
    end;

    methods
        function o = aggr_adaboost(o)
            o.classtitle = 'Adaboost';
        end;
    end;
    
    methods(Access=protected)
        % Adds classifiers when new classes are presented
        function o = do_train(o, data)
            if ~isa(o.sgs, 'sgs_weighted')
                irerror('Invalid SGS: must be of class sgs_weighted or descendant!');
            end;
            
            o.classlabels = data.classlabels;
            osgs = o.sgs.setup(data);
            
            weights = ones(1, data.no);
            de = decider();

            o.betas = zeros(1, o.no_clssrs);
            
            ipro = progress2_open('ADABOOST', [], 0, o.no_clssrs);
            for i = 1:o.no_clssrs
                osgs.weights = weights;
                obsidxs = osgs.get_obsidxs_new();
                
                dtrain = data.split_map(obsidxs(1, 1));
                cl = o.block_mold.boot();
                cl = cl.train(dtrain);
                
                est = cl.use(data);
                est = de.use(est);
                
                flags_missed = renumber_classes(est.classes, est.classlabels, data.classlabels) ~= data.classes;
                
                rateperc = sum(~flags_missed)/data.no;
                beta = (1-rateperc)/(rateperc+realmin);
                o.betas(i) = beta;
                
                
                weights(~flags_missed) = weights(~flags_missed)*beta;
                
                o.blocks(i).block = cl;
                o.blocks(i).classlabels = dtrain.classlabels;
                
                ipro = progress2_change(ipro, [], [], i);
            end;
            progress2_close(ipro);
        end;
    end;
end
    