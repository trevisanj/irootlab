%> @file
%> @ingroup groupgroup

%> @brief Group Aggregator - Classes - Vote
%>
%> @c X property will have the ratio between votes for the assigned class and number of elements in group
classdef grag_classes_vote < grag_classes
    methods
        function o = grag_classes_vote(o)
            o.classtitle = 'Vote';
        end;
    end;
    
    methods(Access=protected)
        function o = process_group(o, idxs)
            classes = o.indata.classes(idxs);
            maxclass = max(classes);
            if maxclass < 0
                o.outdata.X(o.no_out, 1) = 0;
                o.outdata.classes(o.no_out) = -1;
            else
                poll = zeros(1, maxclass+1);
                if isempty(poll)
                    o.outdata.X(o.no_out, 1) = 0;
                    o.outdata.classes(o.no_out) = -1;
                else
                    for i = 1:numel(classes)
                        if classes(i) > -1
                            poll(classes(i)+1) = poll(classes(i)+1)+1;
                        end;
                    end;
                    [val, idx] = max(poll);
                    support = val/numel(classes);
                    o.outdata.X(o.no_out, 1) = support;
                    if support >= o.decisionthreshold
                        o.outdata.classes(o.no_out) = idx-1;
                    else
                        o.outdata.classes(o.no_out) = -1;
                    end;
                end;
            end;
        end;
        
        function o = dim_outdata(o, ng)
            o.outdata.classes(ng, 1) = 0;
            o.outdata.X(ng, 1) = 0;
        end;
    end;
end


















