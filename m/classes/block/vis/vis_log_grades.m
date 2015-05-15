%> @brief Visualization - Grades vector calculated by any @ref as_grades
%>
%> @sa uip_vis_log_grades.m
classdef vis_log_grades < vis
    properties
        data_hint = [];
        flag_trace_minalt = 0;
        flag_abs = 0;
        peakdetector = [];
        flag_envelope = 0;
        flag_bmtable = 0;
    end;
    
    methods
        function o = vis_log_grades(o)
            o.classtitle = 'Grades';
            o.inputclass = 'log_grades';
        end;
    end;
    
    methods(Access=protected)
        function out = do_use(o, obj)
            out = [];
            
            flag_p = ~isempty(o.peakdetector);
            if ~isempty(o.data_hint)
                hintx = o.data_hint.fea_x;
                hinty = mean(o.data_hint.X, 1);
            else
                hintx = [];
                hinty = [];
            end;
            
            if ~o.flag_bmtable
                draw_loadings(obj.fea_x, obj.grades, hintx, hinty, [], o.flag_abs, ...
                              o.peakdetector, o.flag_trace_minalt, flag_p, flag_p, 0, o.flag_envelope);
            else
                draw_loadings_pl(obj.fea_x, obj.grades, hintx, hinty, [], o.flag_abs, ...
                              o.peakdetector);
            end;
            format_xaxis(obj);
            format_yaxis(obj);
            set_title(o.classtitle, obj);
            make_box();
        end;
    end;
end
