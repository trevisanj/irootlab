%> @brief Cascade block: grag_mean -> decider
classdef cascade_gragdecider < block_cascade_base
    methods
        function o = cascade_gragdecider()
            o.classtitle = 'GragMean->Decider';
            o.flag_trainable = 0;
            o.blocks = {grag_mean(), decider()};
        end;
    end;
end