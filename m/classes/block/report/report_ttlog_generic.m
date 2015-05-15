%> @brief @ref ttlog_generic 's HTML (confusion matrices)
%>
%> @sa uip_report_ttlog_generic.m
classdef report_ttlog_generic < irreport
    methods
        function o = report_ttlog_generic()
            o.classtitle = 'Results';
            o.inputclass = 'ttlog_generic';
            o.flag_params = 0;
        end;
    end;
    
    methods(Access=protected)
        function out = do_use(o, obj)
            out = log_html();
            pars = struct();
            out.html = obj.get_insane_html(pars);
            out.title = obj.get_description();
        end;
    end;
end
