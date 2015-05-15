%> @brief Art stuff
%> @ingroup graphicsapi
%> @sa bmtable
classdef bmart_circle < bmart
    methods
        function o = bmart_circle(o)
            o.classtitle = 'Brown Circle';
            o.marker = 'o';
            o.markerscale = 1;
            o.color = [0.8510    0.3725    0.0078];
        end;
    end;
end
