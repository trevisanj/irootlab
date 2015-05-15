%> Feature Extraction - "bypass"
%>
%> This sostage will give always a bypass block - the nf property is ignored.
classdef sostage_fe_bypass < sostage_fe
    methods
        function o = sostage_fe_bypass()
            o.title = '.';
        end;
        
    end;    
    
    methods(Access=protected)
        function out = do_get_block(o) %#ok<MANU>
            out = block_bypass();
        end;
    end;
end
