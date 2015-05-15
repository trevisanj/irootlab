%> @brief Art stuff
%> @ingroup graphicsapi
%>
%> @sa bmtable
classdef bmart_pentagram < bmart
    methods
        function o = bmart_pentagram(o)
            o.classtitle = 'Purple Pentagram';
            o.marker = 'p';
            o.markerscale = 1.67;
            o.color = [0.4588    0.4392    0.7020];
        end;
    end;
end
