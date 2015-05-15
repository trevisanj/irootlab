%> @brief One-versus-all classifier
%>
%> Currently not multitrainable
%>
%> @sa uip_aggr_ova.m
classdef aggr_ova < aggr
    properties
        % must contain a block object that will be replicated as needed
        block_mold = [];
    end;

    methods
        function o = aggr_ova(o)
            o.classtitle = 'One-versus-all';
        end;
    end;
    
    methods(Access=protected)
        function o = do_boot(o)
            o = do_boot@aggr(o);
        end;

        % Adds classifiers when new classes are presented
        function o = do_train(o, data)
            o.classlabels = data.classlabels;

            nc = data.nc;

            blr = blmisc_classlabels_rename();
            
            labels = repmat({'A'}, 1, nc);
            
%             pieces = data_split_classes(data); % Por enquanto assim, mas dava pra tentar um split unico
            o.time_train = 0;
            for i1 = 1:nc
                blr.classlabels_new = labels; % "all"
                blr.classlabels_new{i1} = '0'; % "one" (it is a zero, to sort befora the "A" classes
                
                blk = o.block_mold.boot();
                o.blocks(i1).block = blk.train(data_sort_classlabels(blr.use(data)));
            end;    
        end;
        
        %> Uses blocks and aggregates @c est 's using @c o.esag
        %>
        %> @retval [o, est]
        function est = do_use(o, data)
            
            nb = numel(o.blocks);
            for i = nb:-1:1 % for allocation of ests_
                [o.blocks(i).block, ee] = o.blocks(i).block.use(data);
                
                ests_(i) = ee;
                ests_(i).classlabels = o.classlabels;
                ests_(i).X = zeros(data.no, nb);
                ests_(i).X = repmat(ee.X(:, 2)/(nb-1), 1, nb); % "Dilutes" the "all" posterior
                ests_(i).X(:, i) = ee.X(:, 1);
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