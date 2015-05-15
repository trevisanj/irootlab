%> @brief sostage - Classification QDC
%>
%>
classdef sostage_cl_qdc < sostage_cl
    methods(Access=protected)
        function out = do_get_base(o)
            out = clssr_d();
            out.type = 'quadratic';
            out.flag_use_priors = ~o.flag_cb;
        end;
    end;

    methods
        %> Constructor
        function o = sostage_cl_qdc()
            o.title = 'QDC';
            o.flag_cbable = 1;
        end;
    end;
end
