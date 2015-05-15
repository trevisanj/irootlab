%> @brief Analysis Session (AS) base class.
%>
%> Analysis Session is a block that outputs some @ref irlog, and its internal calculation may take some time, usually with loops etc
%>
%> Often the @ref irlog output is of a class that is specific to the @ref as itself.
classdef as < block
    methods
        function o = as()
            o.classtitle = 'Analysis Session';
            o.flag_bootable = 0;
            o.flag_trainable = 0;
            o.color = [211, 129, 229]/255;
        end;
    end;
end
