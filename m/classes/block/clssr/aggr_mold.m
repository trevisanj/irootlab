%> @brief Fixed, pre-determined components
%>
%> Each time the block is @ref train()ed, a new batch of classifiers (defined by the @ref aggr_mold::block_mold property) will be trained and added.
classdef aggr_mold < aggr
    properties
        %> This can either be a single block or a cell of blocks
        block_mold = [];
    end;

    methods
        function o = aggr_mold(o)
            o.classtitle = 'Molded Ensemble';
            o.flag_ui = 0;
        end;
        
    end;
    
    methods(Access=protected)
        % Adds classifiers when new classes are presented
        function o = do_train(o, data)
            if ~iscell(o.block_mold)
                mold = {o.block_mold};
            else
                mold = o.block_mold;
            end;
            
            for i = 1:numel(mold)
                cl = mold{i}.boot();
                cl = cl.train(data);
                o = o.add_clssr(cl);
            end;
        end;
    end;
end