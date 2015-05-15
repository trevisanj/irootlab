%> FHG - Feature Histogram Generator - set for a LASSO Feature Selection
%>
%>
classdef fhg_lasso < fhg
    methods
        function as_fsel = get_as_fsel(o, ds, dia) %#ok<INUSD>
            as_fsel = as_fsel_lasso();
            as_fsel.nf_select = o.oo.fhg_lasso_nf_select;
        end;
    end;
end
