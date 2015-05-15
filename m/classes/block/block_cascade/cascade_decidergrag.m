%> @brief Cascade block: decider -> grag_classes_vote
classdef cascade_decidergrag < block_cascade_base
    methods
        function o = cascade_decidergrag()
            o.classtitle = 'Decider->GragVote';
            o.flag_trainable = 0;
            o.blocks = {decider(), grag_classes_vote()};
        end;
    end;
end