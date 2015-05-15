%> Feature Extraction Design - Spline
%>
%> fcon_spline does not require training, so by using fearchsel_factors I am introducing unnecessary calculation. However, who cares, this is one
%> of the fastest parts anyway
%>
classdef fearchsel_spline < fearchsel_factors
    methods
        function o = customize(o)
            o.nfs = o.oo.fearchsel_spline_nfs;
        end;
        
        function sos = get_sostage_fe(o)
            sos = sostage_fe_spline();
        end;
    end;
end
