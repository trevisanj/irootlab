%> @brief 1D comparison table
%>
%> Compares performance estimations between several system set-ups
%>
%> The visual output is similar to report_soitem_sovalues, but this one handles
%> soitem_merger_merger_fitest object, which contains the soitem's grouped to do the 2D
%> comparison tables. So, this class has first to call
%> soitem_merger_merger_fitest::get_sovalues_1d().
classdef report_soitem_merger_merger_fitest_1d < report_soitem
%     properties
%         %> =(auto). Minimum value for the colour scaling of the HTML cells
%         minimum = [];
%         %> =(auto). Maximum value for the colour scaling of the HTML cells
%         maximum = [];
%     end;
%     


    properties
        %> =1. Whether to generate the p-values tables
        flag_ptable = 1;
        
        %> ={'rates', 'times3'}
        names = {'rates', 'times3'}
        
        %> vectorcomp_ttest_right() with no logtake. vectorcomp object used tor the p-values tables
        vectorcomp = [];

        %> Maximum number of table rows
        maxrows = 20;
    end;

    methods
        function o = report_soitem_merger_merger_fitest_1d()
            o.classtitle = '1D comparison table';
            o.inputclass = 'soitem_merger_merger_fitest';
%             o.flag_params = 1;
        end;
    end;
    
    methods(Access=protected)
        function out = do_use(o, item)
            out = log_html();
            
            s = o.get_standardheader(item);
            
            out.html = [s, o.get_html_graphics(item)];
            out.title = item.get_description();
        end;
    end;

    
    methods
        %> Generates a table with the best in each architecture, with its respective time and confidence interval
        %> @param item a soitem_merger_merger_fitest object
        function s = get_html_graphics(o, item)
%             it = soitem_sovalues();
            sov = item.get_sovalues_1d();
%             r = report_soitem_sovalues();
            
            r = report_sovalues_comparison();
            r.dimspec = {[0, 0], [1, 2]};
            r.flag_ptable = o.flag_ptable;
            r.names = o.names;
            r.vectorcomp = o.vectorcomp;
            r.maxrows = o.maxrows;
            
            s = r.get_html_tables(sov);
        end;
    end;
end
