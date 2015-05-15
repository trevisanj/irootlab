%> @brief Comparison and p-values tables
%>
%> Compares performance estimations between several system set-ups
%>
%> @todo implement the params GUI
classdef report_soitem_sovalues < report_soitem
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
        function o = report_soitem_sovalues()
            o.classtitle = '1D comparison table';
            o.inputclass = 'soitem_sovalues';
            o.flag_params = 0;
        end;
    end;
    
    methods(Access=protected)
        function out = do_use(o, obj)
            out = log_html();
            
            r = report_sovalues_comparison();
            r.dimspec = {[0, 0], [1, 2]};
            r.flag_ptable = o.flag_ptable;
            r.names = o.names;
            r.vectorcomp = o.vectorcomp;
            r.maxrows = o.maxrows;
            
            out.html = [o.get_standardheader(obj), r.get_html_tables(obj.sovalues)];
            out.title = obj.get_description();
        end;
    end;

    methods
        function v = some_items(o, nar, choiceidx)
            if isempty(choiceidx)
                v = 1:o.maxrows;
            else
                A = .4;
%                 share1 = A;
                share2 = 1-A; % percentages of items destinated for the first items and items around choiceidx respectively

                nit = min(o.maxrows, nar);

                i1 = floor(choiceidx-share2/2*nit);
                i2 = ceil(choiceidx+share2/2*nit);
                i0 = nit-((i2-i1)+1);

                if i1 <= i0
                    dif = i0-i1+1;
                    i1 = i1+dif;
                    i2 = i2+dif;
                end;

                if i2 > nar;
                    dif = i2-nar;
                    i1 = i1-dif;
                    i2 = i2-dif;
                end;

                v = [1:i0, i1:i2];
            end;
        end;
    end;
end
