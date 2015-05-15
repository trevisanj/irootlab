%> @brief sostage - Classification Distance
%>
%>
classdef sostage_cl_dist < sostage_cl
    methods(Access=protected)
        function out = do_get_base(o)
            out = clssr_dist();
            out.flag_use_priors = ~o.flag_cb;
        end;
    end;
    
    methods
        %> Constructor
        function o = sostage_cl_dist()
            o.title = 'Distance';
            o.flag_cbable = 1;
        end;
    end;
end
