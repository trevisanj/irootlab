%> @brief 3D Scatterplot
%> @sa data_draw_scatter_3d.m, uip_vis_scatter3d.m
classdef vis_scatter3d < vis
    properties
        %> =[1, 2, 3] Index of features to be uses as coordinates. Must be a 3-element vector.
        idx_fea = [1, 2, 3];
        %> =[] . Vector of confidence percentages (between 0 and 1) for drawing the confidence ellipsoids. If left
        %> empty, no confidence ellipsoid is drawn.
        confidences = [];
        
        textmode = 0;
    end;
    
    methods
        function o = vis_scatter3d(o)
            o.classtitle = '3D Scatterplot';
            o.inputclass = 'irdata';
        end;
    end;
    
    methods(Access=protected)
        function out = do_use(o, obj)
            out = [];
            data_draw_scatter_3d(obj, o.idx_fea, o.confidences, o.textmode);
            set_title(o.classtitle, obj);
        end;
    end;
end
