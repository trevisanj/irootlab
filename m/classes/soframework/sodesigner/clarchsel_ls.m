%> architecture optimization for the ls classifier
%>
%>
classdef clarchsel_ls < clarchsel_noarch
    methods
        function o = customize(o)
            o = customize@clarchsel_noarch(o);
        end;

        function sos = get_sostage_cl(o)
            sos = sostage_cl_ls();
            sos = o.setup_sostage_cl(sos, 1);
        end;
    end;
end
