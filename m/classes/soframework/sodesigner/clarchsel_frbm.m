%> architecture optimization for the frbm classifier
%>
%> Plamen says that the scale should be 1 for standardized data. Amen.
%>
%>
classdef clarchsel_frbm < clarchsel_noarch
    methods
        function o = customize(o)
            o = customize@clarchsel_noarch(o);
%             o.nfs = o.oo.clarchsel_frbm_nfs;
        end;

        function sos = get_sostage_cl(o)
            sos = sostage_cl_frbm();
            sos = o.setup_sostage_cl(sos, 1);
            sos.scale = 1;
            sos.flag_perclass = 0;
            sos = o.customize_sostage_cl(sos);
        end;
    end;
end    

