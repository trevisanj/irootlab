%> Pre-processing - "bypass"
%>
%> This sostage will give always a bypass block - the nf property is ignored.
classdef sostage_pp_bypass < sostage_pp
    methods
        function o = sostage_pp_bypass()
            o.title = '.';
        end;
        
    end;    
    
    methods(Access=protected)
        function out = do_get_block(o) %#ok<MANU>
            out = block_bypass();
        end;
        
        function out = do_get_bio(o)
            out = o.do_get_block();
        end;
    end;
end
