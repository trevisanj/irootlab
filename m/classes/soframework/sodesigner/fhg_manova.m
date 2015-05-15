%> FHG-MANOVA
%>
%> @note This is also a Forward Feature Selection, but it does not use a classifier!
%>
classdef fhg_manova < fhg
    methods
        function fb = get_as_fsel(o, ds, dia) %#ok<*INUSD>
            fsg = fsg_test_manova();
            fsg.flag_logtake = 1;
            
            fb = as_fsel_forward();
            fb.nf_select = o.oo.fhg_manova_nf_select;
            fb.fsg = fsg;
        end;
    end;
end
