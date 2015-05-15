%> @brief Subtracts the mean of a reference class from all the rows
%>
%> @sa uip_pre_sub_refmean.m
classdef pre_sub_refmean < pre
    properties
        %> =1. Index of reference class (1-based = first class is class "1")
        idx_refclass = 1;
    end;
    
    methods
        function o = pre_sub_refmean(o)
            o.classtitle = 'Subtract mean of a reference class';
        end;
    end;
    
    methods(Access=protected)
        function data = do_use(o, data)
            me = mean(data.X(data.classes == (o.idx_refclass-1), :));
            
            data.X = data.X-repmat(me, data.no, 1);
        end;
    end;
end