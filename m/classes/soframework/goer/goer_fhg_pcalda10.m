%> Goer for the FHG_PCAL<DA class - 10 factors for PCA
classdef goer_fhg_pcalda10 < goer_1i
    methods
        function o = setup(o)
            o.classname = 'fhg_pcalda';
        end;

        function d = customize_session(o, d)
            d.oo.fhg_pcalda_no_factors = 10;
        end;
    end;
end
