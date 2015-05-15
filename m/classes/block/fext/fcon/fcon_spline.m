%> @brief B-Splines Decomposition
%
%> <h3>References</h3>
%>   Ramsay JO. MATLAB, R and S-PLUS Functions for Functional Data Analysis. 2005:1-66.
%>   ftp://ego.psych.mcgill.ca/pub/ramsay/FDAfuns/R/inst/Matlab/fdaM/FDAfuns.pdf
%>   (Accessed on 10/Dec/2010)
%> @todo Should make the basis on training, not only use!
%>
%> @sa uip_fcon_spline.m
classdef fcon_spline < fcon_linear
    properties
        %> Number of basis functions transformed dataset (default: 30).
        no_basis = 30;
        %> Breakpoints, given in x-axis indexes, in case one wants to fine-tune the splines (optional) (see reference).
        breaks = [];
        %> Splines order (default: 6) (see reference).
        order = 6;
    end;
    
    properties(SetAccess=protected)
        %> New feature x-axis. See that this transformation keeps the x-axis unit!
        fea_x_new;
    end;
    
    methods
        function o = fcon_spline()
            o.classtitle = 'B-Splines Decomposition';
            o.short = 'B-Splines';
            o.flag_trainable = 1;
        end;
    end;
    
    methods(Access=protected)
        function o = do_train(o, data)
            if isempty(o.breaks)
                bb = create_bspline_basis([1, data.nf], o.no_basis, o.order);
            else
                bb = create_bspline_basis([1, data.nf], o.no_basis, o.order, round(o.breaks));
            end;
            
            % First makes a new x vector.
            % It will contain the x-axis location where the splines peak
            PREC = 1000; % This number only determines the precision and does not affect anything else.
            tt = 1:data.nf;
            tt2 = linspace(1, data.nf, PREC); 
            warning off;
            p = polyfit(tt, [data.fea_x], min(data.nf-1, 10));
            warning off;
            x2 = polyval(p, tt2);
            basismat = eval_basis(tt2, bb); % bases as columns
            [vals, idxs] = max(basismat);
            o.fea_x_new = x2(idxs);


            % Now the main task   
            % We gotta get the loadings matrix
            tt3 = 1:data.nf;
            B = eval_basis(tt3, bb);
            o.L = B/(B'*B); % L, the "loadings" matrix calculated by Least-Squares
            o.L_fea_x = data.fea_x;
            o.xname = data.xname;
            o.xunit = data.xunit;
        end;
         
        function data = do_use(o, data)
            data = data.transform_linear(o.L, o.L_fea_prefix);
            data.fea_x = o.fea_x_new;
        end;
    end;
end