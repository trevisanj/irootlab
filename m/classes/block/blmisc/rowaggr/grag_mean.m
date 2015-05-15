%> @file
%> @ingroup groupgroup

%> @brief Group Aggregator - averages rows per group
classdef grag_mean < grag
    methods
        function o = grag_mean()
            o.classtitle = 'Mean';
            o.inputclass = 'irdata';
        end;
    end;

    methods(Access=protected)
        function o = process_group(o, idxs)
%             if ~isempty(o.indata.groupcodes)
%                 irverbose(sprintf('Group %s - #%d', o.indata.groupcodes{idxs(1)}, numel(idxs)));
%             end;    
            o.outdata.X(o.no_out, :) = mean(o.indata.X(idxs, :), 1);
            if ~isempty(o.indata.classes)
                o.outdata.classes(o.no_out) = o.indata.classes(idxs(1)); % Takes class from first row of the group
            end;
        end;
        
        function o = dim_outdata(o, ng)
            o.outdata.X(ng, o.indata.nf) = 0;
            o.outdata.classes(ng, 1) = 0;
        end;
    end;
end