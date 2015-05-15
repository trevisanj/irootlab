% @brief IROBJ's report
classdef report_default < irreport
    methods
        function o = report_default()
            o.classtitle = 'Default report';
            o.inputclass = 'irobj';
            o.flag_params = 0;
            o.flag_graphics = 0;
        end;
    end;
    
    methods(Access=protected)
        function out = do_use(o, obj)
            out = log_html;
            out.html = obj.get_html();
            out.title = obj.get_description();
        end;
    end;
end
