%> @brief @ref ttlog 's HTML (confusion matrices
%>
%> @sa uip_vis_ttlog_html.m
classdef report_ttlog < irreport
    properties
        flag_individual = 0;
    end;
    
    methods
        function o = report_ttlog()
            o.classtitle = 'ttlog default';
            o.inputclass = 'ttlog';
        end;
    end;
    
    methods(Access=protected)
        function out = do_use(o, obj)
            out = log_html();
            pars.flag_individual = o.flag_individual;
            out.html = obj.get_insane_html(pars); 
            out.title = obj.get_description();
        end;
    end;
end
