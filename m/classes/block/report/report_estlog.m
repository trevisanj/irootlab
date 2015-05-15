%> @brief @ref estlog 's HTML (confusion matrices)
%>
%> @sa uip_report_estlog.m
classdef report_estlog < irreport
    properties
        flag_individual = 0;
        flag_balls = 1;
    end;
    
    methods
        function o = report_estlog()
            o.classtitle = 'Confusion matrices';
            o.inputclass = 'estlog';
        end;
    end;
    
    methods(Access=protected)
        function out = do_use(o, obj)
            out = log_html();
            pars.flag_individual = o.flag_individual;
            pars.flag_balls = o.flag_balls;
            out.html = obj.get_insane_html(pars);
            out.title = obj.get_description();
        end;
    end;
end
