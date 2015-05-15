%> @brief Visualization - All curves in dataset
classdef vis_alldata < vis
    properties
        %> =0. Whether to use plot_curve_pieces
        %> This property is not editable in the GUI
        flag_pieces = 0;
        %> =0 If 0, will use one color inside the COLORS global per class.
        %>    If 1, will use one color inside the COLORS global per data row
        flag_color_per_row = 0;
    end;
        
    methods
        function o = vis_alldata()
            o.classtitle = 'All curves in dataset';
            o.inputclass = 'irdata';
            o.flag_params = 0;
        end;
    end;
    
    methods(Access=protected)
        function out = do_use(o, obj)
            out = [];
            data_draw(obj, o.flag_pieces, o.flag_color_per_row);
            make_box();
            set_title(o.classtitle, obj);
        end;
    end;
end
