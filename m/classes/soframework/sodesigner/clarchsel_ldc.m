%> architecture optimization for the ldc classifier
%>
%>
classdef clarchsel_ldc < clarchsel_noarch
    methods
        function o = customize(o)
            o = customize@clarchsel_noarch(o);
        end;

        function sos = get_sostage_cl(o)
            sos = sostage_cl_ldc();
            sos = o.setup_sostage_cl(sos, 1);
        end;
    end;
end
