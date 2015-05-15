%> @brief sostage - Classification LDC/QDC
%>
%>
classdef sostage_pp_std < sostage_pp
    
    methods
        function o = sostage_pp_std()
            o.title = 'Standardization';
        end;
    end;
        
    methods(Access=protected)
        function a = get_blocks(o)
            out = pre_norm();
            out.types = 's';
            a = {out};
        end;
    end;
end
