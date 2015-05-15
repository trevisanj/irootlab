%> Architecture optimization for the frbm classifier - kg1ginal rule updating
%>
%>
classdef clarchsel_frbm_kg1 < clarchsel_frbm
    methods
        function sos = customize_sostage_cl(o, sos)
            sos.s_f_update_rules = 'frbm_update_rules_kg1';
        end;
    end;
end
