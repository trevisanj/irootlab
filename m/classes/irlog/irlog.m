%> @brief Log base class
%>
%> <h3>Definition and purpose</he>
%> irobj descendant with arbitrary structure to carry outputs of blocks.
classdef irlog < irobj
    methods
        function o = irlog(o)
            o.classtitle = 'Log';
            o.color = [250, 234, 130]/255;
        end;
    end;
end
