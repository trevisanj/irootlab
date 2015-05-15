%> @brief sostage - Classification LDC
%>
%>
classdef sostage_cl_ldc < sostage_cl
    methods(Access=protected)
        function out = do_get_base(o)
            out = clssr_d();
            out.type = 'linear';
            out.flag_use_priors = ~o.flag_cb;
        end;
    end;
    
    methods
        %> Constructor
        function o = sostage_cl_ldc()
            o.title = 'LDC';
            o.flag_cbable = 1;
        end;
    end;
end
