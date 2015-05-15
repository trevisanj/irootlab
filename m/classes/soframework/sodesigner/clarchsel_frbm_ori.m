%> Architecture optimization for the frbm classifier - original rule updating
classdef clarchsel_frbm_ori < clarchsel_frbm
    methods
        function sos = customize_sostage_cl(o, sos)
            sos.s_f_update_rules = 'frbm_update_rules_original';
        end;
    end;
end
