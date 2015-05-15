%> @brief Visualization - 3D Scatterplot - Ellipse Walls
%> @sa data_draw_scatter_3d2.m, uip_vis_scatter3d2.m
classdef vis_scatter3d2 < vis
    properties
        %> =[1, 2, 3] Index of features to be uses as coordinates. Must be a 3-element vector.
        idx_fea = [1, 2, 3];
        %> =[] . Vector of confidence percentages (between 0 and 1) for drawing the confidence ellipsoids. If left
        %> empty, no confidence ellipsoid is drawn.
        confidences = [];
        %> =[1, 1, 1]
        flags_min = [1, 1, 1];
        %> =[0.2, 0.5]
        ks = [0.2, 0.5];
        %> =0. Whether to project the points onto the walls
        flag_wallpoints = 0;
    end;
    
    methods
        function o = vis_scatter3d2(o)
            o.classtitle = '3D Scatterplot - Ellipse Walls';
            o.inputclass = 'irdata';
        end;
    end;
    
    methods(Access=protected)
        function out = do_use(o, obj)
            out = [];
            data_draw_scatter_3d2(obj, o.idx_fea, o.confidences, o.flags_min, o.ks, o.flag_wallpoints);
            set_title(o.classtitle, obj);
        end;
    end;
end