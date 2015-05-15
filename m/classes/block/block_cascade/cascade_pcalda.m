%> @brief Cascade block: fcon_pca -> fcon_lda
classdef cascade_pcalda < block_cascade_base
    methods
        function o = cascade_pcalda()
            o.classtitle = 'PCA->LDA';
            o.flag_trainable = 1;
            o.blocks = {fcon_pca(), fcon_lda()};
        end;
    end;
end