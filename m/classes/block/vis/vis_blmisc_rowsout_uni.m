%> @brief Visualization for @ref blmisc_rowsout_uni objects. Invokes the outlier removal Preview dialog.
classdef vis_blmisc_rowsout_uni < vis
    methods
        function o = vis_blmisc_rowsout_uni(o)
            o.classtitle = 'Preview dialog';
            o.inputclass = 'blmisc_rowsout_uni';
            o.flag_params = 0;
            o.flag_graphics = 0;
        end;
    end;
    
    methods(Access=protected)
        function out = do_use(o, obj)
            out = [];
            orhistgui(obj);
        end;
    end;
end
