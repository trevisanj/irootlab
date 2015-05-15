%> @brief Combines features extracted from two or more blocks in parallel
classdef fext_parallel < fext
    properties
        blocks;
    end;
    
    methods
        function o = fext_parallel()
            o.classtitle = 'Parallel';
            o.flag_ui = 0;
            o.flag_trainable = 1;
        end;
    end;
    
    methods(Access=protected)
        %> Boots every encapsulated block
        function o = do_boot(o)

            for i = 1:length(o.blocks)
                o.blocks{i} = o.blocks{i}.boot();
            end;
        end;

        %> Trains every encapsulated block
        function o = do_train(o, data)
            
            for i = 1:numel(o.blocks)
                o.blocks{i} = o.blocks{i}.train(data);
            end;
        end;
        
        %> output of (k-1)-th block is inputted into k-th block. Final output is the output of the end-th block.
        function data = do_use(o, data)
            for i = length(o.blocks):-1:1
                du(i) = o.blocks{i}.use(data);
            end;
            
            data = data_merge_cols(du);
        end;
    end;
end
