%> @file
%> @ingroup groupgroup

%> @brief Group Aggregator - classes
classdef grag_classes < grag
    properties
        %> =0 Refuse-to-decide threshold. See @c decider.m for more on that.
        decisionthreshold = 0;
    end;
    
    methods
        function o = grag_classes(o)
            o.classtitle = 'Class';
            o.inputclass = 'estimato';
        end;
    end;
    
    methods(Access=protected)
        %> Abstract.
        function o = process_group(o, idxs)
%             o.outdata.X(o.no_out, :) = mean(o.indata.X(idxs, :), 1);
%             o.outdata.classes(o.no_out) = o.indata.classes(idxs(1)); % Takes class from first row of the group
        end;
        
        function o = dim_outdata(o, ng)
            o.outdata.X(ng, o.indata.nf) = 0;
            o.outdata.classes(ng, 1) = 0;
        end;
    end;
end