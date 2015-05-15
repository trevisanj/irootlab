%> @brief Merges contents of many log_html
%>
%> @sa uip_report_estlog.m
classdef reportmerger < irreport
    properties
        flag_individual = 0;
        flag_balls = 1;
    end;
    
    methods
        function o = reportmerger()
            o.classtitle = 'Report merger';
            o.inputclass = 'log_html';
            o.flag_multiin = 1;
            o.flag_params = 0;
        end;
    end;
    
    methods(Access=protected)
        function out = do_use(o, in)
            out = log_html();
            out.title = 'Merge';
            
            nin = numel(in);
            for i = 1:nin
                if i > 1
                    out.html = cat(2, out.html, '<hr />', 10);
                end;
                out.html = cat(2, out.html, '<h1>', sprintf('Report %d/%d', i, nin), ' - ', in(i).classtitle, ' - ', in(i).title, '</h1>', 10, in(i).html);
            end;
        end;
    end;
end
