%> @brief Cascade: fsel -> pre_bc_rubber -> pre_norm
classdef cascade_cbn < block_cascade_base
    methods
        function o = cascade_cbn()
            o.classtitle = 'Cut->RubberBC->Normalization';
            o.flag_trainable = 0;
            o.blocks = {fsel(), pre_bc_rubber(), pre_norm()};
        end;
    end;
end