%> @brief Visualization base class
%>
%> Vis sets figures titles
classdef vis < block
    properties
        %> =1. Whether the visualization is a graphic one (otherwise will be text). This is to help automatic GUI
        %> behaviour.
        flag_graphics = 1;
    end;
    
    methods
        function o = vis()
            o.classtitle = 'Visualization';
            o.flag_out = 0;
            o.flag_trainable = 0;
            o.flag_fixednf = 0;
        end;
    end;
end