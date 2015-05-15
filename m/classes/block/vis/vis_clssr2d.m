%> @brief Classification Domain - classification regions etc
classdef vis_clssr2d < vis
    methods
        function o = vis_clssr2d(o)
            o.classtitle = 'Classification Domain';
            o.inputclass = 'clssr';
        end;
    end;
    
    methods(Access=protected)
        %> @todo still TODO
        function out = do_use(o, obj)
            out = [];

        end;
    end;
end