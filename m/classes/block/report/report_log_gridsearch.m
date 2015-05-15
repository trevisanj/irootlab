%> @brief Shows best parameters at each 
classdef report_log_gridsearch < irreport
    properties
    end;
    
    methods
        function o = report_log_gridsearch()
            o.classtitle = 'Grid Search Log Report';
            o.inputclass = 'log_gridsearch';
            o.flag_params = 0;
        end;
    end;
    
    methods(Access=protected)
        function out = do_use(o, log)
            out = log_html();
            out.html = ['<h1>', log.title, '</h1>', 10, o.get_reportbody(log)];
%             out.title = log.get_description();
        end;
    end;

    
    methods
        %> Generates a table with the best in each architecture, with its respective time and confidence interval
        %> @param sov sovalues object
        function s = get_reportbody(o, log)
            s = '';
            vv = log.sovaluess;
            n = numel(vv);
            for i = 1:n
                r =vv(i);
                ch = r.chooser;
                coords = ch.use(r.values);
                rr = r.values(coords{:}).rates;
                s = cat(2, s, '<p>', r.title, sprintf(' (<font color=blue>classification rate: %.4g%% &plusmn; %.4g%%</font>)', ...
                                                      mean(rr), std(rr)), ...
                              '</p>', 10, '<ul>', 10); % This is supposed to contain the iteration and move indexes
                for j = 1:numel(coords)
                    s = cat(2, s, '<li>', r.ax(j).legends{coords{j}}, '</li>', 10);
                end;
                s = cat(2, s, '</ul>');
            end;
        end;
    end;
end
