%> architecture optimization for the knn classifier
%>
%> Specs are nf and k
classdef clarchsel_knn < clarchsel
    % Automatically set
    properties
        ks;
        nfs;
    end;
    
    methods
        function o = customize(o)
            o = customize@clarchsel(o);
            o.ks = o.oo.clarchsel_knn_ks;
            o.nfs = o.oo.clarchsel_knn_nfs;
        end;
    end;

    methods(Access=protected)
        function out = do_design(o)
            item = o.input;
            dia = item.get_modifieddia();
            % Customizes diagnosissystem
            sos = sostage_cl_knn();
            sos = o.setup_sostage_cl(sos, 0);
            dia.sostage_cl = sos;
            
            ds = o.oo.dataloader.get_dataset();
            ds = dia.preprocess(ds);
            
            % Makes a matrix of blocks
            nk = numel(o.ks);
            nfe = numel(o.nfs);
            molds = cell(nfe, nk);
            for j = 1:nfe
                for ik = 1:nk
                    dia.sostage_cl.k = o.ks(ik);
                    specs{j, ik} = sprintf('nf=%d, k=%d', o.nfs(j), o.ks(ik));
                    dia.sostage_fe.nf = o.nfs(j);
                    molds{j, ik} = dia.get_fecl();
                    sostages{j, ik} = dia.sostage_cl;
                end;
            end;

            r = o.go_cube(ds, molds, sostages, specs);

            r.ax(1) = raxisdata_nfs(o.nfs);
            r.ax(2) = raxisdata_unit('k', 'k', o.ks);
            
            out = soitem_sostagechoice();
            out.sovalues = r;
            out.dia = item.get_modifieddia();
            out.dstitle = ds.title;
            out.title = o.make_title_dia(out.dia);
        end;
    end;
end
