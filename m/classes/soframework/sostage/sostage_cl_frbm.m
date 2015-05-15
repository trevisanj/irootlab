%> @brief sostage - Classification eClass1 (Takagi-Sugeno order 1 only!)
%>
%>
classdef sostage_cl_frbm < sostage_cl  
    properties
        %> =0.5 . frbm's scale
        scale = 0.5;
        
        %> =0 . frbm's flag_perlass
        flag_perclass = 0;
        
        %> ='frbm_update_rules_kg1'. frbm's s_f_update_rules
        s_f_update_rules = 'frbm_update_rules_kg1';

    end;
    
    methods(Access=protected)
        function out = do_get_base(o)
            out = frbm();
            out.scale = 0.5;
            out.epsilon = exp(-1);
            out.flag_consider_Pmin = 1;
            out.flag_perclass = 0;
            out.flag_clone_rule_radii = 1;
            out.flag_iospace = 1;
            out.s_f_get_firing = 'frbm_firing_exp_default';
            out.s_f_update_rules = 'frbm_update_rules_kg1';
            out.flag_rls_global = 0;
            out.rho = 0.5;
            out.ts_order = 1;
            out.flag_wta = 0;
            out.flag_class2mo = 1;
            out.title = 'eClass1';
            out.flag_counterbalance = 0;

            out.flag_counterbalance = o.flag_cb;
            out.scale = o.scale;
            out.flag_perclass = o.flag_perclass;
            out.s_f_update_rules = o.s_f_update_rules;
        end;
    end;
    
    methods
        %> Constructor
        function o = sostage_cl_frbm()
            o.title = 'eClass1';
            o.flag_cbable = 1;
        end;
    end;
end
