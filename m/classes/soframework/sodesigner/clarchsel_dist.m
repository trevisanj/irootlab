%> architecture optimization for the dist classifier
%>
%>
classdef clarchsel_dist < clarchsel_noarch
    methods
        function o = customize(o)
            o = customize@clarchsel_noarch(o);
%             o.nfs = o.oo.clarchsel_dist_nfs;
        end;
            
        function sos = get_sostage_cl(o)
            sos = sostage_cl_dist();
            sos = o.setup_sostage_cl(sos, 1);
        end;
    end;
end
