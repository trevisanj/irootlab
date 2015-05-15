%> @brief system optimizer stage doer - Classification generic
%>
%>
classdef sostage_cl < sostage
    properties
        %> Counterbalance?
        flag_cb = 0;
        %> Whether to go pairwise
        flag_pairwise = 0;
        %> Whether to undersample
        flag_under = 0;
        %> Number of component classifiers in the undersampling
        under_no_reps = 0;
        %> Random seed for the SGS that will undersample the dataset for the classifier
        under_randomseed = 0;
    end;

    properties(SetAccess=protected)
        %> =1. Is "counterbalanceable"?
        flag_cbable = 1;
        %> =0. Whether the classifier works with only two classes
        flag_2class = 0;
    end;
    
    
    methods(Access=protected, Abstract)
        %> (Abstract) This is the method which returns the base classifier that may be wrapped (see source of do_get_block())
        blk = do_get_base(o);
    end;

    methods
% % % % % %         %> Overriden so that it does NOT set the block title
% % % % % %         function blk = get_block(o)
% % % % % %             blk = o.do_get_block();
% % % % % %         end;
        
        function s = get_blocktitle(o)
            s = o.title;
            if o.flag_under
                s = [s, '(U', int2str(o.under_no_reps), ')'];
            end;
            if o.flag_pairwise || o.flag_2class
                s = [s, '(OVO)'];
            end;
        end;
    end;

    
    
    %> Methods reimplemented
    methods(Access=protected)
        %> Returns classifier properly encapsulated
        %>
        %> Either:
        %> @arg single classifier
        %> @arg pairwise(classifier)
        %> @arg undersampling(classifier)
        %> @arg pairwise(undersampling(classifier))
        %>
        %> Note that if pairwise and undersampling, undersampling will be performed first (because pairwising will operate on smaller
        %> datasets)
        function blk = do_get_block(o)
            blk = o.get_base();

            % If the classifier is 2-class only, will always FORCE PAIRWISE
            % This will affect the LASSo classifier only at this point, and will not change much of the results.
            % This was the simplest way to account for this exception without having to mess code around too much
            if o.flag_2class
                o.flag_pairwise = 1;
            end;
            
            if o.flag_under
                os = sgs_randsub();
                os.randomseed = o.under_randomseed;
                os.bites = 1;
                os.flag_perclass = 1;
                os.no_reps = o.under_no_reps;
                os.type = 'balanced';
                os.flag_group = 0;

                % I am setting the title because this may be wrapped inside a
                % agg_pairs, with title out of the reach of sostage.get_block()
                u = aggr_bag();
                u.title = [blk.title, '(U', int2str(o.under_no_reps), ')'];
                u.sgs = os;
                u.block_mold = blk;
                
                blk = u;
            end;
            
            if o.flag_pairwise
                agg = aggr_pairs(); % mold
                agg.block_mold = blk;
                blk = agg;
            end;
        end;
    end;
    
    
    methods(Sealed)
        %> Returns the base classifier
        function blk = get_base(o)
            blk = o.do_get_base();
% % % % %             blk.title = o.title;
% % % % %             blk.short = o.title;
        end;
    end;
end
