%> Feature Extraction Design - Forward Feature Selection using a Classifier
%>
%>
classdef fearchsel_ffs < fearchsel_fs_base
    methods
        %> Constructor
        function o = fearchsel_ffs()
            o.classtitle = 'FFS';
        end;

        function fb = get_as_fsel(o, ds, dia)
            if dia.sostage_cl.flag_under
                % Restricts undersampling to one only
                dia.sostage_cl.under_no_reps = 1;
            end;
            
            [pr_t, pr_e] = o.oo.cubeprovider.get_postpr();
            sgs = o.oo.cubeprovider.get_sgs_crossval();

            lo = estlog_classxclass();

            lo.estlabels = ds.classlabels;
            lo.testlabels = ds.classlabels;
            lo.flag_inc_t = 0;

            fsg = fsg_clssr();
            fsg.postpr_est = pr_e;
            fsg.postpr_test = pr_t;
            fsg.estlog = lo;
            fsg.sgs = sgs;
            fsg.fext = pre_std();
            fsg.clssr = dia.sostage_cl.get_block();

            % the FS object itself
            fb = as_fsel_forward();
            fb.nf_select = o.oo.fearchsel_ffs_nf_max;
            fb.fsg = fsg;
        end;        
    end;    
end
