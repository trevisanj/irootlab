%> @brief Visualization - Per-Feature Histogram 3D
classdef vis_3dhist < vis
    methods
        function o = vis_3dhist(o)
            o.classtitle = 'Per-Feature Histogram 3D';
            o.inputclass = 'irdata';
            o.flag_params = 0;
        end;
    end;
    
    methods(Access=protected)
        function out = do_use(o, obj)
            out = [];
            data_draw_3dhist(obj);
            set_title(o.classtitle, obj);
        end;
    end;
end
