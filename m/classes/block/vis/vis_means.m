%> @brief Visualization - Class means
classdef vis_means < vis
    properties
        peakdetector;
        %> =1. whether to plot_curve_pieces or just plot. Not editablie in the GUI uip_vis_means at the moment.
        flag_pieces = 1;
    end;
    
    methods
        function o = vis_means(o)
            o.classtitle = 'Class means';
            o.inputclass = 'irdata';
            o.flag_params = 1;
        end;
    end;
    
    methods(Access=protected)
        function out = do_use(o, obj)
            out = [];
            data_draw_means(obj, o.peakdetector, o.flag_pieces);
            set_title(o.classtitle, obj);
            make_box();
        end;
    end;
end
