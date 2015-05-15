%> @brief Savitsky-Golay (SG) Differentiation
%>
%> See also: diff_sg.m, uip_pre_diff_sg.m
classdef pre_diff_sg < pre
    properties
        %> =1. Differentiation order.
        order = 1;
        %> =2. Polynomial order.
        porder = 2;
        %> =9. Number of coefficients of filter.
        ncoeff = 9;
    end;

    
    methods
        function o = pre_diff_sg(o)
            o.classtitle = 'Differentiation SG';
            o.short = 'DiffSG';
        end;
    end;
    
    methods(Access=protected)
        function data = do_use(o, data)
            [data.X, data.fea_x] = diff_sg(data.X, data.fea_x, o.order, o.porder, o.ncoeff);
        end;
    end;
end