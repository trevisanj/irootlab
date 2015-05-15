%> Merges individual cross-validated estimates from several fitest outputs into a single soitem_diachoice with a sovalues to be looked at
classdef merger_fitest < sodesigner
    % Bit lower level
    methods(Access=protected)
        function out = do_design(o)
            items = o.input;
            ni = numel(items);
            
            for i = 1:ni
                titles{i, 1} = items{i}.diaa{1}.get_s_sequence([], 1);
                values(i, 1) = sovalues.read_logs(items{i}.logs);
                specs{i, 1} = items{i}.diaa{1}.get_s_sequence([], 1);
                diaaa{i, 1} = items{i}.diaa;
            end;
            
            r = sovalues();
            r.chooser = o.oo.diacomp_chooser;
            r.values = values;
            r = r.set_field('title', titles);
            r = r.set_field('spec', specs);
            r = r.set_field('diaa', diaaa);
            
            r.ax(1) = raxisdata();
            r.ax(1).label = 'System';
            r.ax(1).values = 1:ni;
            r.ax(1).legends = titles;

            r.ax(2) = raxisdata_singleton();

            out = soitem_diachoice();
            out.sovalues = r;
            out.title = ['(Set-ups + estimations) merge (', int2str(ni), ' item', iif(ni > 1, 's', ''), ')'];
            out.dstitle = items{1}.dstitle;
        end;
    end;
end
