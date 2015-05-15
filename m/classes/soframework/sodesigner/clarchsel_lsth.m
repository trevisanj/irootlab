%> architecture optimization for the "LSTH" (Least Squares feature THreshold) classifier
%>
%> This classifier has embedded feature selection and is similar to LASSO in this sense.
%>
%>
classdef clarchsel_lsth < clarchsel
    properties
        nfs;
    end;
    
    methods
        function o = customize(o)
            o = customize@clarchsel(o);
            o.nfs = o.oo.clarchsel_lsth_nfs;
        end;
    end;
    
    methods(Access=protected)
        function out = do_design(o)
            item = o.input;
            dia = item.get_modifieddia();
            sos = sostage_cl_lsth();
            sos = o.setup_sostage_cl(sos, 1);

            ds = o.oo.dataloader.get_dataset();
            ds = dia.preprocess(ds);
            
            % Makes a vector of blocks
            nfe = numel(o.nfs);
            molds = cell(nfe, 1);
            for j = 1:nfe
                specs{j, 1} = sprintf('nf=%d', o.nfs(j));
                sos.nf = o.nfs(j);
                molds{j, 1} = make_one({pre_std(), sos.get_block()});
                sostages{j, 1} = sos;
            end;
            
            r = o.go_cube(ds, molds, sostages, specs);

            r.ax(1) = raxisdata_nfs(o.nfs);
            r.ax(2) = raxisdata_singleton();
            
            out = soitem_sostagechoice();
            out.sovalues = r;
            out.dia = item.get_modifieddia();
        end;
    end;
end

