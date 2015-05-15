%> @brief Splits dataset into many according to classes
%>
%> @sa uip_blmisc_split_classes.m
classdef blmisc_split_classes < blmisc_split
    properties
        hierarchy = [];
    end;
    
    methods
        function o = blmisc_split_classes(o)
            o.classtitle = 'Classes';
        end;
    end;
    
    methods(Access=protected)
        function datasets = do_use(o, data)
            datasets = data_split_classes(data, o.hierarchy);
        end;
    end;  
end

