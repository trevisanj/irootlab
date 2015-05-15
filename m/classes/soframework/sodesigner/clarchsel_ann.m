%> architecture optimization for the ann classifier
%>
%> system specs are nf and architecture only
classdef clarchsel_ann < clarchsel
    properties
        archs;
        nfs;
    end;
    
    methods
        function o = customize(o)
            o = customize@clarchsel(o);
            o.nfs = o.oo.clarchsel_ann_nfs;
            o.archs = o.oo.clarchsel_ann_archs;
        end;
    end;

    methods(Access=protected)
        %> Compares different architectures; records best architecture, rates, times for statistics
        function out = do_design(o)
            item = o.input;
            dia = item.get_modifieddia();
            ds = o.oo.dataloader.get_dataset();
            ds = dia.preprocess(ds);
          
            % Customizes diagnosissystem
            sos = sostage_cl_ann();
            sos = o.setup_sostage_cl(sos, 1);
            dia.sostage_cl = sos;

            % Makes a matrix of blocks
            narchs = numel(o.archs);
            nfe = numel(o.nfs);
            molds = cell(nfe, narchs);
            for j = 1:nfe
                for k = 1:narchs
                    dia.sostage_cl.hiddens = o.archs{k};
                    specs{j, k} = sprintf('nf=%d, arch=%s', o.nfs(j), mat2str(o.archs{k}));
                    dia.sostage_fe.nf = o.nfs(j);
                    molds{j, k} = dia.get_fecl();
                    sostages{j, k} = dia.sostage_cl;
                end;
            end;

            r = o.go_cube(ds, molds, sostages, specs);

            r.ax(1) = raxisdata_nfs(o.nfs);
            r.ax(2).label = 'Architecture';
            r.ax(2).values = 1:narchs;
            r.ax(2).legends = cellfun(@(x) mat2str(x), o.archs, 'UniformOutput', 0);

            
            out = soitem_sostagechoice();
            out.sovalues = r;
            out.dia = item.get_modifieddia();
            out.title = o.make_title_dia(out.dia);
        end;
    end;
end
