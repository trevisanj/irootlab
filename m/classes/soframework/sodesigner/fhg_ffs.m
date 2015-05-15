%> FHG - Feature Histogram Generator - set for a Forward Feature Selection using a classifier
classdef fhg_ffs < fhg_fswrapper
    methods
        function fb = do_get_as_fsel(o) 
            fb = as_fsel_forward();
            fb.nf_select = o.oo.fhg_ffs_nf_select;
        end;
    end;
end
