%> Feature Extraction Design - PCA
%>
%>
classdef fearchsel_pca < fearchsel_factors
    methods
        function o = customize(o)
            o.nfs = o.oo.fearchsel_pca_nfs;
        end;
        
        function sos = get_sostage_fe(o)
            sos = sostage_fe_pca();
        end;
    end;
end
