%> @brief "Mutant" block / metablock
%>
%> At train(), becomes the output of its block
classdef mutant < block
    properties
        block;
    end;
        
    methods
        function o = mutant()
            o.flag_ui = 0;
            o.flag_trainable = 1;
        end;
        
        function z = train(o, input)
            b = o.block.boot();
            b = b.train(input);
            z = b.use(input);
        end;
    end;
end
