%> Feature Extraction Design - PLS
%>
%>
classdef fearchsel_pls < fearchsel_factors
    methods
        function o = customize(o)
            o.nfs = o.oo.fearchsel_pls_nfs;
        end;
        
        function sos = get_sostage_fe(o)
            sos = sostage_fe_pls();
        end;
    end;
end
