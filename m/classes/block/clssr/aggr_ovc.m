%> @brief One-versus-"control" classifier
%>
%> Currently not multitrainable
classdef aggr_ovc < aggr
    properties
        % must contain a block object that will be replicated as needed
        block_mold = [];
    end;

    methods
        function o = aggr_ovc(o)
            o.classtitle = 'One-versus-reference';
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

%             blr = blmisc_classlabels_rename();
            
%             pieces = data_split_classes(data); % Por enquanto assim, mas dava pra tentar um split unico
            o.time_train = 0;
            for i1 = 2:nc
                blk = o.block_mold.boot();
                o.blocks(i1-1).block = blk.train(data_split_classmap(data, [1, i1]));
                o.blocks(i1-1).classlabels = data.classlabels(1, i1);
            end;    
        end;

        %{
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
        %}
    end;
end