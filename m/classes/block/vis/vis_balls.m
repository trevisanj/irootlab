%> @brief Visualization - Balls visualization for Confusion Matrices
classdef vis_balls < vis
    methods
        function o = vis_balls(o)
            o.classtitle = 'Confusion Balls';
            o.inputclass = {'irconfusion'};
            o.flag_params = 0;
        end;
    end;
    
    methods(Access=protected)
        function out = do_use(o, obj)
            obj.draw_balls();
            out = [];
        end;
    end;
end