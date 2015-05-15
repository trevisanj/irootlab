%> @brief Visual representation of selected features
classdef vis_log_as_fsel < vis
    properties
        data_hint = [];
        flag_mark = 0;
    end;
    
    methods
        function o = vis_log_as_fsel(o)
            o.classtitle = 'Features Selected';
            o.inputclass = 'log_as_fsel';
        end;
    end;
    
    methods(Access=protected)
        function out = do_use(o, obj)
            out = [];
            obj.draw(o.data_hint, o.flag_mark);
            set_title(o.classtitle, obj);
        end;
    end;
end
