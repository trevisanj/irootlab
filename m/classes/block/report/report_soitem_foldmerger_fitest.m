%> @brief Passes on to report_estlog, to show confusion matrices
%>
classdef report_soitem_foldmerger_fitest < report_soitem
    methods
        function o = report_soitem_foldmerger_fitest()
            o.classtitle = 'Confusion matrices';
            o.inputclass = 'soitem_foldmerger_fitest';
            o.flag_params = 0;
        end;
    end;
    
    
    
    methods(Access=protected)
        function out = do_use(o, obj)
            out = log_html();
            
            or = report_estlog();
            log_or = or.use(obj.logs{1});
            out.html = [o.get_standardheader(obj), log_or.html];
            out.title = obj.get_description();
        end;
    end;
end
