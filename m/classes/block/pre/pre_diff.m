%> @brief Simple differentiation using MATLAB @c diff() function
%>
%> @sa uip_pre_diff.m
classdef pre_diff < pre
    properties
        %> =1. Differentiation order
        order = 1;
    end;
    
    methods
        function o = pre_diff(o)
            o.classtitle = 'Differentiation';
            o.short = 'Diff';
        end;
    end;
    
    methods(Access=protected)
        function data = do_use(o, data)
            data.fea_x = data.fea_x(o.order+1:end);
            data.X = diff(data.X, o.order, 2);
        end;
    end;
end