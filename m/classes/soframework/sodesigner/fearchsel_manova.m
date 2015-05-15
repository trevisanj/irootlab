%> Feature Extraction Design - Forward Feature Selection using MANOVA
%>
%>
classdef fearchsel_manova < fearchsel_fs_base
    methods
        %> Constructor
        function o = fearchsel_manova()
            o.classtitle = 'FS_MANOVA';
        end;

        function fb = get_as_fsel(o, ds, dia)
            fsg = fsg_test_manova();
            fsg.flag_logtake = 1;

            % the FS object itself
            fb = as_fsel_forward();
            fb.nf_select = o.oo.fearchsel_manova_nf_max;
            fb.fsg = fsg;
        end;        
    end;    
end
