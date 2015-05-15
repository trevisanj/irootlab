%> @brief Asymmetric Least-Squares Baseline Correction
%>
%> you can vary the values of 'lambda' and 'p' to see the effect on
%> smoothness, also the base line
%>
%> <h3>Reference:</h3>
%> Baseline Correction with Asymmetric Least Squares Smoothing. Paul H. C. Eilers, Hans F.M. Boelens. October 21, 2005
%>
%> @sa uip_pre_bc_asls.m
classdef pre_bc_asls < pre_bc
    properties
        %> =0.001. Recommended: 0.001 <= @p p <= 0.1
        p = 0.001;
        %> =1e5. Recommended: 10^2 <= @p lambda <= 10^9
        lambda = 1e5;
        %> =10
        no_iterations = 10;
    end;

    
    methods
        function o = pre_bc_asls(o)
            o.classtitle = 'Asymmetric Least-Squares Smoothing';
            o.short = 'BCALSM';
        end;
    end;
    
    methods(Access=protected)
        
        
        %> Applies block to dataset
        function data = go_use(o, data)
            X = data.X;

            for j = 1:data.no
                aa = X(j, :)';

                %> Estimate baseline with asymmetric least squares
                m = length(aa);
                D = diff(speye(m), 2);
                w = ones(m, 1);

                for it = 1:o.no_iterations
                    W = spdiags(w, 0, m, m);
                    C = chol(W + o.lambda * D' * D);
                    z = C \ (C' \ (w .* aa));
                    w = o.p * (aa > z) + (1 - o.p)*(aa < z);
                end

                X(j,:) = aa-z;
            end
            
            data.X = X;
        end;
    end;
end