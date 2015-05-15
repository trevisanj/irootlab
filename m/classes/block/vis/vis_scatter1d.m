%> @brief 1D Scatterplot
%>
%> @sa data_draw_scatter_1d.m, uip_vis_scatter1d.m
classdef vis_scatter1d < vis
    properties
        idx_fea = 1;
        type_distr = 1;
    end;
    
    methods
        function o = vis_scatter1d(o)
            o.classtitle = '1D Scatterplot';
            o.inputclass = 'irdata';
        end;
    end;
    
    methods(Access=protected)
        function out = do_use(o, obj)
            out = [];
            data_draw_scatter_1d(obj, o.idx_fea, o.type_distr);
            set_title(o.classtitle, obj);
            make_box();
        end;
    end;
end
