%> @brief 2D Scatterplot
%>
%> Visualizations with subplots. Uses title of subplots as x-label
%>
%> @sa data_draw_scatter_2d.m, uip_vis_scatter2d.m
classdef vis_scatter2d < vis
    properties
        %> =[1,2]
        idx_fea = [1, 2];
        confidences = [];
        textmode = 0;
    end;
    
    methods
        function o = vis_scatter2d(o)
            o.classtitle = '2D Scatterplot';
            o.inputclass = 'irdata';
        end;
    end;
    
    methods(Access=protected)
        function out = do_use(o, obj)
            out = [];
            data_draw_scatter_2d(obj, o.idx_fea, o.confidences, o.textmode);
            make_box();
        end;
    end;
end
