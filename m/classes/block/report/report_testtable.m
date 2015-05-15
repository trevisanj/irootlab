% @brief Test table using FSG and single variable.
classdef report_testtable < irreport
    properties
        idx_fea = 1;
        %> =def_fsg(). A FSG object
        fsg = def_fsg_testtable();
    end;
    
    methods
        function o = report_testtable()
            o.classtitle = 'Test table';
            o.inputclass = 'irdata';
            o.flag_params = 1;
        end;
    end;
    
    methods(Access=protected)
        function out = do_use(o, data)
            out = log_html();
            out.html = o.get_html_table(data);
            out.title = ['Test table', data.get_description()];
        end;
    end;
    
    methods
        function s = get_html_table(o, data)
            f = def_fsg_testtable(o.fsg);
            f.flag_logtake = 0;
            data = data.select_features(o.idx_fea);
            pieces = data_split_classes(data);

            h = arrayfun(@(s) ['<td class="tdhe">', s{1}, '</td>'], data.classlabels, 'UniformOutput', 0);
            s = '';
            s = cat(2, s, ['<h1>', '"', f.classtitle, '" table for dataset ', data.get_description(), '</h1>', 10, ...
                '<p>FSG description: <b>', o.fsg.get_description(), '</b></p>', 10, ...
                '<table class=bo>', 10, '<tr>', ...
                '<td class="tdhe">class \ class</td>', strcat(h{:}), '</tr>', 10]);
            
            for i = 1:data.nc
                s = cat(2, s, ['<tr><td class="tdle">', data.classlabels{i}, '</td>', 10]);

                for j = 1:data.nc
                    ds = data_merge_rows(pieces([i, j]));
                    f.data = ds;
                    f = f.boot();
                    p = f.calculate_grades({1});
%                     p = vc.test(pieces(i).X(:, o.idx_fea), pieces(j).X(:, o.idx_fea)); %#ok<ASGLU>
                    s = cat(2, s, ['<td class="tdnu">', num2str(p), '</td>', 10]);
                end;
                
                s = cat(2, s, ['</tr>', 10]);
            end;
            
            s = cat(2, s, ['</table>', 10]);
        end;
    end;
end
