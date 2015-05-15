%> @brief Cascade block: pre_diff_sg -> pre_norm_vector
classdef cascade_diffvn < block_cascade_base
    methods
        function o = cascade_diffvn()
            o.classtitle = 'SG Differentiation->Vector normalization';
            o.flag_trainable = 0;
            o.blocks = {pre_diff_sg(), pre_norm_vector()};
        end;
    end;
end