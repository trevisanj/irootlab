%> @file
%> @ingroup groupgroup

%> @brief Group Aggregator - Classes - Weighted Vote
%>
%> @c X property of output will have the ratio between the sum of weights for for the assigned class and total sum of weights in
%> group.
%>
%> Acts on estimato datasets already processed by a decider. The relevant thing is that the X property must have the support for the
%class decided
classdef grag_classes_votew < grag_classes
    methods
        function o = grag_classes_votew(o)
            o.classtitle = 'Weighted vote';
        end;
    end;
    
    methods(Access=protected)
        function o = process_group(o, idxs)
            % Extracts from dataset for faster manipulation
            classes = o.indata.classes(idxs);
            X = o.indata.X(idxs, :);
            
            poll = zeros(1, max(classes)+1); % Initializes poll
            if isempty(poll)
                o.outdata.X(o.no_out, 1) = 0;
                o.outdata.classes(o.no_out) = -1;
            else
                for i = 1:numel(classes)
                    if classes(i) > -1
                        poll(classes(i)+1) = poll(classes(i)+1)+X(i, 1);
                    end;
                end;
                [val, idx] = max(poll);
                support = val/sum(poll);
                o.outdata.X(o.no_out, 1) = support;
                if support >= o.decisionthreshold
                    o.outdata.classes(o.no_out) = idx-1;
                else
                    o.outdata.classes(o.no_out) = -1;
                end;
            end;
        end;
        
        function o = dim_outdata(o, ng)
            o.outdata.classes(ng, 1) = 0;
            o.outdata.X(ng, 1) = 0;
        end;
    end;
end












