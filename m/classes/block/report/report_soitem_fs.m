%> @brief Plots the (nf)x(rates) curve
%>
classdef report_soitem_fs < report_soitem
    methods
        function o = report_soitem_fs()
            o.classtitle = '(nf)x(rates) curve';
            o.inputclass = 'soitem_fs';
            o.flag_params = 0;
        end;
    end;
    
    methods(Access=protected)
        function out = do_use(o, obj)
            out = log_html();
            out.html = [o.get_standardheader(obj), o.images_1d(obj.sovalues)];
            out.title = obj.get_description();
        end;
    end;

end
