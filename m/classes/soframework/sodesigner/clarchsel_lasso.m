%> architecture optimization for the lasso classifier
%>
%> specs are nf
classdef clarchsel_lasso < clarchsel
    properties
        nfs;
    end;
    
    methods
        function o = customize(o)
            o = customize@clarchsel(o);
            o.nfs = o.oo.clarchsel_lasso_nfs;
        end;
    end;
    
    methods(Access=protected)
        function out = do_design(o)
            item = o.input;
            dia = item.get_modifieddia();
            dia.sostage_fe = sostage_fe_bypass; % Feature extraction is embedded within LASSO
            sos = sostage_cl_lasso();
            sos = o.setup_sostage_cl(sos, 0);
            sos.flag_precond = 0;
%             sos.precond_threshold = 0.1;
%             sos.precond_no_factors = 15;

            ds = o.oo.dataloader.get_dataset();
            ds = dia.preprocess(ds);

            no_feature_s = o.nfs;
            no_feature_s(no_feature_s > rank(ds.X)) = [];

            
            % Makes a vector of blocks
            nfe = numel(no_feature_s);
            molds = cell(nfe, 1);
            for j = 1:nfe
                specs{j, 1} = sprintf('nf=%d', no_feature_s(j));
                sos.nf = no_feature_s(j);
                molds{j, 1} = make_one({pre_std(), sos.get_block()});
                sostages{j, 1} = sos; %#ok<AGROW>
            end;
            
            r = o.go_cube(ds, molds, sostages, specs);

            r.ax(1) = raxisdata_nfs(no_feature_s);
            r.ax(2) = raxisdata_singleton();
            
            out = soitem_sostagechoice();
            out.sovalues = r;            
            out.dia = dia;
            out.dstitle = ds.title;
            out.title = o.make_title_dia(out.dia);
        end;
    end;
end
