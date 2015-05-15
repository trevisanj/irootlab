%> @brief Base class for all ensemble classifiers
%>
%> Multiple Training-compatible
%>
%> @sa uip_aggr.m
classdef aggr < clssr
    properties
        %> =esag_linear1. Estimation Aggregator object
        esag = esag_linear1();
        %> =0. Whether to record the estimations of the component classifiers into the object (@c o ) itself in the @c do_use() method.
        flag_ests = 0;
    end;
    
    properties
        %> (Read-only) @c estimato objects carried out of @c do_use() if @c flag_ests is true
        ests;
        %> (Read-only) Structure array with fields @c block and @c classlabels
        blocks;
    end;

    methods
        function o = aggr(o)
            o.classtitle = 'Ensemble';
        end;
        
        function o = add_clssr(o, cl)
            nb = numel(o.blocks);
            o.blocks(nb+1).block = cl;
            o.blocks(nb+1).classlabels = cl.classlabels;
            o.classlabels = union(o.classlabels, cl.classlabels);
        end;
        
% %         % TODO not sure about this, gotta see where used, then find solution
% %         function z = getbatch(o, propname)
% %             no_mod = length(a.blocks);
% %             % initializes output
% %             out = 0;
% % 
% %             for m = 1:no_mod
% %                 eval(sprintf('out = out+a.blocks{%d}.%s;', m, propname));
% %             end;
% %         end
    end;
    
    methods(Access=protected)

        %> Deletes all components and creates default @ref aggr::esag if needed
        function o = do_boot(o)
            o.blocks = struct('block', {}, 'classlabels', {});
            if isempty(o.esag)
                o.esag = esag_linear1();
            end;
        end;
        
        %> Default training passes same dataset to each block.
        function o = do_train(o, data)
            nb = numel(o.blocks);
            for i = 1:nb
                o.blocks{i}.block = o.blocks{i}.block.train(data);
            end;
        end;
        
        %> Uses blocks and aggregates @c est 's using @c o.esag
        %>
        %> @retval [o, est]
        function est = do_use(o, data)

            nb = numel(o.blocks);
            for i = 1:nb
                [o.blocks(i).block, ests_(i)] = o.blocks(i).block.use(data);
                ests_(i) = ests_(i).change_classlabels(o.classlabels);
            end;

            est = o.esag.use(ests_);
            if o.flag_ests
                o.ests = ests_;
            else
                o.ests = [];
            end;
        end;
    end;
end