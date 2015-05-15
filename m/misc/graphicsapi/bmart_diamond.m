%> @brief Art stuff
%> @ingroup graphicsapi
%> @sa bmtable
classdef bmart_diamond < bmart
    methods
        function o = bmart_diamond(o)
            o.classtitle = 'Black Diamond';
            o.marker = 'd';
            o.markerscale = 1;
            o.color = [0, 0, 0];
        end;
    end;
end
