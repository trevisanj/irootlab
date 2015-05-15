%> architecture optimization for the svm classifier
%>
%> I used this once to fine-fune the C, gamma boundaries (for different datasets) to get nice images and make sure that the
%> optimal is within boundaries
%>
%>
classdef clarchsel_svm < clarchsel
    properties
        nfs;
        cs;
        gammas;
    end;
    
    methods
        function o = customize(o)
            o = customize@clarchsel(o);
            o.cs = o.oo.clarchsel_svm_cs;
            o.gammas = o.oo.clarchsel_svm_gammas;
            o.nfs = o.oo.clarchsel_svm_nfs;
        end;
    end;
    
    methods(Access=protected)
        function out = do_design(o)
            item = o.input;
            dia = item.get_modifieddia();
            % Customizes diagnosissystem
            sos = sostage_cl_svm();
            sos = o.setup_sostage_cl(sos, 0); % Note that although SVM can counterbalance in the formula, it is not very effective, therefore not used by default
            dia.sostage_cl = sos;

            ds = o.oo.dataloader.get_dataset();
            ds = dia.preprocess(ds);

            % Makes a cube of blocks
            nc = numel(o.cs);
            ngamma = numel(o.gammas);
            nfe = numel(o.nfs);
            molds = cell(nfe, nc, ngamma);
            for ife = 1:nfe
                for ic = 1:nc
                    for igamma = 1:ngamma
                        dia.sostage_cl.c = o.cs(ic);
                        dia.sostage_cl.gamma = o.gammas(igamma);
                        specs{ife, ic, igamma} = sprintf('nf=%d, c=%.3g, gamma=%.3g', o.nfs(ife), o.cs(ic), o.gammas(igamma));
                        dia.sostage_fe.nf = o.nfs(ife);
                        molds{ife, ic, igamma} = dia.get_fecl();
                        sostages{ife, ic, igamma} = dia.sostage_cl;
                    end;
                end;
            end;

            r = o.go_cube(ds, molds, sostages, specs);
            
            r.ax(1) = raxisdata_nfs(o.nfs);
        
            r.ax(2).label = 'log_{10}(C)';
            r.ax(2).values = log10(o.cs);
%             r.ax(2).legends = arrayfun(@(x) sprintf('C=%.3g', x), o.cs, 'UniformOutput', 0);

            r.ax(3).label = 'log_{10}(\gamma)';
            r.ax(3).values = log10(o.gammas);
%             r.ax(3).legends = arrayfun(@(x) sprintf('gamma=%.3g', x), o.gammas, 'UniformOutput', 0);

            out = soitem_sostagechoice();
            out.sovalues = r;
            out.dia = item.get_modifieddia();
            out.dstitle = ds.title;
            out.title = o.make_title_dia(out.dia);
        end;
    end;
end
