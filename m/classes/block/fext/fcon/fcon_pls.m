%> @brief Partial Least Squares Transformation aka PLSDA
%>
%> This function uses @c plsregress() from MATLAB's Statistics Toolbox
%>
%> The "Y" in the PLS formulation used is <code>classes2boolean(data.classes)</code>
%>
%> @sa uip_fcon_pls.m
classdef fcon_pls < fcon_linear
    properties
        %> Number of factors to feature in the transformed dataset (default: 10).
        no_factors = 10;
    end;

    methods
        function o = fcon_pls(o)
            o.classtitle = 'Partial Least Squares';
            o.short = 'PLS';
            o.flag_trainable = 1;
            o.L_fea_prefix = 'PLS';
        end;
    end;
    
    methods(Access=protected)
        function o = do_train(o, data)
%             o.L = irootlab_pls(data.X, data.classes, o.no_factors);
            [o.L, dummy] = plsregress(data.X, classes2boolean(data.classes), o.no_factors);
            o.L_fea_x = data.fea_x;
            o.xname = data.xname;
            o.xunit = data.xunit;
        end;
    end;
end