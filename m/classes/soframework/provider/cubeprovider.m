%> @brief Provides a reptt_blockcube object
%>
%> The idea of these "provider" class is to serve as data (parameters) storage and produce objects when requested, using the
%> stored data to set-up the object.
%>
classdef cubeprovider
    properties
        %> =0. Whether to parallelize the optimization. This is actually passed on to the @ref reptt_blockcube that is created
        flag_parallel = 0;

        %> =0. Cross-validation random seed
        randomseed = 0;

        %> =0. Random seed for get_sgs_fhg_stab()
        randomseed_stab = 0;
        
        %> Cross-validation "k"
        no_reps;
        
        %> Number of sub-samples for the "randsub"
        no_reps_fhg;

        %> Number of sub-samples for the "inner randsub" (get_sgs_fhg_stab())
        %> taskmanager takes care of setting this.
        no_reps_stab;

        
        %> ttlogprovider object
        ttlogprovider;

        %> Whether to make the reptt_blockcube's postprocessors with group (colony) aggregation
        flag_grag = 0;
        %> Whether to make the reptt_blockcube's postprocessors with group (colony) refuse-to-classify threshold
        flag_decisionthreshold = 0;
        %> If refuse-to-classify threshold is being used, which value it is going to be
        decisionthreshold = 0.6;

        %> = 1. Whether to group by colony. This makes sense to be deactivated if the dataset already contains the colony averages
        flag_group = 1;
        
    end;
    
    methods     
        %> Makes a reptt_blockcube object to be used to evaluate several blocks using the same (possibly parallelized) cross-validation loop
        function u = get_cube(o, data)

            u = reptt_blockcube();
            u.log_mold = o.ttlogprovider.get_ttlogs(data);
            u.sgs = o.get_sgs_crossval();
            u.flag_parallel = o.flag_parallel;

            [pr_t, pr_e] = o.get_postpr();
            u.postpr_test = pr_t;
            u.postpr_est = pr_e;...
        end;
    
        %> Makes post-processors
        function [postpr_test, postpr_est] = get_postpr(o)
            de = decider();
            if o.flag_decisionthreshold
                de.decisionthreshold = o.decisionthreshold;
            end;

            if o.flag_grag
                gr = grag_mean();
                postpr_test = gr;
                postpr_est = block_cascade();
                postpr_est.blocks = {gr, de};
            else
                postpr_test = [];
                postpr_est = de;
            end;
        end;

        %> Returns the sgs_randsub object, probably to be used for a histogram generation
        function u = get_sgs_fhg(o)
            u = sgs_randsub();
            u.flag_group = o.flag_group;
            u.flag_perclass = 1;
            u.randomseed = o.randomseed;
            u.bites = [.9, .1];  % proportion of 10-fold crossvalidation
            u.no_reps = o.no_reps_fhg; 
        end;
        
        %> Returns a sgs_randsub object to be used in Feature Histogram generation, when there is a nested cross-validation
        function u = get_sgs_fhg_stab(o)
            u = sgs_randsub();
            u.flag_group = o.flag_group;
            u.flag_perclass = 1;
            u.randomseed = o.randomseed_stab;
            u.bites = [.9, .1];  % proportion of 10-fold crossvalidation
            u.no_reps = o.no_reps_stab; 
        end;
        
        %> Returns the sgs_crossval object to be used in the sgs_blockcube object
        function u = get_sgs_crossval(o)
            u = sgs_crossval();
            u.flag_group = o.flag_group;
            u.flag_perclass = 1;
            u.randomseed = o.randomseed;
            u.flag_loo = 0;
            u.flag_autoreduce = 1; % Will automatically reduce "k" if the dataset does not allow for so.
            u.no_reps = o.no_reps; 
        end;
    end;
    
end
