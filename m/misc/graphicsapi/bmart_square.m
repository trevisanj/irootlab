%> @brief Art stuff
%> @ingroup graphicsapi
%>
%> @sa bmtable
classdef bmart_square < bmart
    methods
        function o = bmart_square(o)
            o.classtitle = 'Green Square';
            o.marker = 's';
            o.markerscale = 1;
            o.color = [0.1059    0.6196    0.4667];
        end;
    end;
end
