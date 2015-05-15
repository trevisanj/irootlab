%> @brief Principal Component Analysis
%>
%> @sa uip_fcon_pca.m
classdef fcon_pca < fcon_linear
    properties
        %> = 1: whether to rotate factors or not.
        flag_rotate_factors = 0;
        %> = 10: number of factors to feature in the transformed dataset.
        no_factors = 10;
    end;
    
    methods
        function o = fcon_pca(o)
            o.classtitle = 'Principal Component Analysis';
            o.short = 'PCA';
            o.flag_trainable = 1;
            o.L_fea_prefix = 'PC';
        end;
    end;
    
    methods(Access=protected)
               
        function o = do_train(o, data)
            if sum(var(data.X) < 1e-10) > 0
                irverbose('WARNING: There are variables with variance lower than 1e-10, something may go wrong here!', 3);
            end;

            V_star = princomp2(data.X);

            if o.no_factors > 0
                no_factors_eff = min(o.no_factors, size(V_star, 2));
                V_star = V_star(:, 1:no_factors_eff);
            else
                no_factors_eff = size(V_star, 2);
            end;

            if o.flag_rotate_factors
                V_star = rotatefactors2(V_star, 1);
            end;


            o.L = V_star;
            o.L_fea_x = data.fea_x;
            o.xname = data.xname;
            o.xunit = data.xunit;
        end;
        
        %> Overriden to imprint variance percentages in feature names
        function data = do_use(o, data)
            C = cov(data.X);
            totalVar = sum(diag(C));
            data = do_use@fcon_linear(o, data);
            for i = 1:data.nf
                varNow = var(data.X(:, i))/totalVar*100;
                data.fea_names{i} = sprintf('%s%d (%.3g%%)', o.L_fea_prefix, data.fea_x(i), varNow);
            end;
        end;
    end;
end