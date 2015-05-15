%> items property is an array of soitem_diachoice()
classdef soitem_merger_merger_fitest < soitem
    properties
        %> Array of soitem_merger_fitest objects
        items = soitem_diachoice.empty();
    end;
    
    % -*-*-*-*-*- TOOLS
    methods
        %> @param varargin see @ref get_biocomparisontable
        %> @return [s, M, titles] @s is HTML; M is the comparison cube; @c titles describes each row in M
        %>
        %> @sa get_biocomparisoncube()
        function [s, Y] = html_rates(o, minimum, maximum)
            so = o.get_sovalues();
            Y = so.get_Y('rates');
            means = mean(Y, 3);
            stds = std(Y, [], 3);
            s = ['<center>', html_table_std_colors(round(means*100)/100, round(stds*100)/100, so.ax(1).ticks, so.ax(2).ticks, '', minimum, maximum), '</center>', 10];
            
        end;
    end;        
    
    %------> Low-level tools
    methods
        
        function out = get_sovalues(o)
            ni = numel(o.items);

            out = sovalues();
            out.chooser = o.items(1).sovalues.chooser;
            out.ax(1) = o.items(1).sovalues.ax(1);
            out.ax(1).ticks = uniquenesses({o.items(1).sovalues.values.title});
            for i = 1:ni
                if i == 1
                    out.values = o.items(i).sovalues.values(:);
                else
                    out.values(:, i) = o.items(i).sovalues.values(:);
                end;
                titles{i} = o.items(i).sovalues.values(1).title;
            end;
            
%             out.ax(1) = raxisdata();
%             out.ax(1).label = 'System';
%             out.ax(1).values = 1:ni;
%             out.ax(1).legends = titles;
            
            out.ax(2) = raxisdata();
            out.ax(2).label = 'Model';
            out.ax(2).ticks = uniquenesses(titles);
        end;
        
        
        %> Concatenates all values into one
        function out = get_sovalues_1d(o)
            ni = numel(o.items);

            out = sovalues();
            out.chooser = o.items(1).sovalues.chooser;
            out.ax(2) = o.items(1).sovalues.ax(2);
            out.ax(1) = o.items(1).sovalues.ax(1);
            out.ax(1).ticks = uniquenesses({o.items(1).sovalues.values.title});
            for i = 1:ni
                if i == 1
                    out.values = o.items(i).sovalues.values;
                    out.ax(1) = o.items(1).sovalues.ax(1);
                else
                    out.values = [out.values; o.items(i).sovalues.values];
                    out.ax(1).values = [out.ax(1).values, o.items(i).sovalues.ax(1).values];
                    out.ax(1).ticks = [out.ax(1).ticks, o.items(i).sovalues.ax(1).ticks];
                    out.ax(1).legends = [out.ax(1).legends, o.items(i).sovalues.ax(1).legends];
                end;
%                 titles{i} = o.items(i).sovalues.values(1).title;
            end;
            
%             out.ax(1) = raxisdata();
%             out.ax(1).label = 'System';
%             out.ax(1).values = 1:ni;
%             out.ax(1).legends = titles;
            
%             out.ax(2) = raxisdata();
%             out.ax(2).label = 'Model';
%             out.ax(2).ticks = uniquenesses(titles);
        end;
    end;
end
