%> @brief sostage - Classification LS with threshold
%>
%> @todo Needs some work on it
%>
%>
classdef sostage_cl_lsth < sostage_cl
    properties
        nf;
    end;


    methods(Access=protected)
        function out = do_get_base(o)
            out = clssr_ls();
            out.flag_weighted = o.flag_cb;
            out.nf_select = o.nf;
        end;
    end;
    
    methods
        %> Constructor
        function o = sostage_cl_lsth()
            o.title = 'LSTh';
            o.flag_cbable = 1;
        end;
    end;
end
