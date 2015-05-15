%> @brief sostage - Classification ls
%>
%>
classdef sostage_cl_ls < sostage_cl
    methods(Access=protected)
        function out = do_get_base(o)
            out = clssr_ls();
            out.flag_weighted = o.flag_cb;
        end;
    end;
    
    methods
        %> Constructor
        function o = sostage_cl_ls()
            o.title = 'LS';
            o.flag_cbable = 1;
        end;
    end;
end
