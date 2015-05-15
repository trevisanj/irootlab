%> @file
%> @ingroup groupgroup

%> @brief Group Aggregator - Classes - First row
%>
%> Useful to aggregate test dataset to compare with aggregated @c estimato. Assigns the class of first group observation to the group class; @c X left empty.
classdef grag_classes_first < grag_classes
    methods
        function o = grag_classes_first(o)
            o.classtitle = 'First Row';
        end;
    end;
    
    methods(Access=protected)
        function o = process_group(o, idxs)
            o.outdata.classes(o.no_out) = o.indata.classes(idxs(1));
        end;
        
        function o = dim_outdata(o, ng)
            o.outdata.classes(ng, 1) = 0;
        end;
    end;
end