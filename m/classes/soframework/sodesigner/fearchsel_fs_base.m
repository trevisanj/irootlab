%> Feature Extraction Design - Feature Selection base
%>
%>
classdef fearchsel_fs_base < fearchsel
    methods
        %> Constructor
        function o = fearchsel_fs_base()
            o.classtitle = 'FS(?)';
        end;
    end;

    methods
        function o = customize(o)
            % The FFS itselt unfortunately cannot be parallelized, although it is the most time consuming operation within the design
            % (which has two parts).
            %
            % Therefore, if an intention to go parallel is detected, the flags are corrected to get the most of parallelization.
            o.paralleltype = 'outer';
        end;
    end;
    
    methods(Abstract)
        as_fsel = get_as_fsel(o, ds, dia);
    end;
    
    methods(Access=protected)
        %> Finds "v"
        function out = do_design(o)
            item = o.input;
            dia = item.get_modifieddia();
            ds = o.oo.dataloader.get_dataset();
            ds = dia.preprocess(ds);
            
            %*********************************************************
            % First part

            ofs = o.get_as_fsel(ds, dia);
            
            nf_select_eff = min(ofs.nf_select, ds.nf);
            if nf_select_eff < ofs.nf_select
                irverbose(sprintf('Info: Maximum number of features was limited by dataset nf. Will be %d instead of %d', nf_select_eff, ds.nf), 2);
            end;
            
            ofs.nf_select = nf_select_eff;
            log = ofs.use(ds);


            %*********************************************************
            % Second part!

            dia.sostage_fe = sostage_fe_fs();
            dia.sostage_fe.v = log.v; % feature vector
            dia.sostage_fe.title = o.classtitle;
            
            % Makes a matrix of blocks
            molds = cell(nf_select_eff, 1);
            sostages = cell(nf_select_eff, 1);
            for j = 1:nf_select_eff
                specs{j, 1} = sprintf('nf=%d', j);
                dia.sostage_fe.nf = j;
                molds{j, 1} = dia.get_fecl();
                sostages{j, 1} = dia.sostage_fe;
            end;

            r = o.go_cube(ds, molds, sostages, specs);

            r.ax(1) = raxisdata_nfs(1:nf_select_eff);
            r.ax(2) = raxisdata_singleton();
            
            out = soitem_fs();
            out.sovalues = r;
            out.dia = item.get_modifieddia();
            out.log_as_fsel = log;
            out.dstitle = ds.title;
            out.title = o.make_title_dia(out.dia);
        end;        
    end;    

end
