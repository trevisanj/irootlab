%> @brief Fisher's Linear Discriminant Analysis
%> @sa fisher_ld.m, uip_fcon_lda.m
classdef fcon_lda < fcon_linear
    properties
        flag_sphere = 0;
        flag_modified_s_b = 0;
        %> Penalty coefficients: [0-th derivative penalty, 1st derivative penalty, 2nd ..., ...]
        penalty = 0;
        max_loadings;
    end;
    
    methods
        function o = fcon_lda(o)
            o.classtitle = 'Linear Discriminant Analysis';
            o.short = 'LDA';
            o.flag_trainable = 1;
            o.L_fea_prefix = 'LD';
        end;

    end;
    
    methods(Access=protected)
        function o = do_train(o, data)
            [o.L, lambdas] = fisher_ld(data, o.flag_sphere, o.flag_modified_s_b, o.penalty, o.max_loadings);
            o.L_fea_x = data.fea_x;
            o.xname = data.xname;
            o.xunit = data.xunit;
        end;
    end;
end