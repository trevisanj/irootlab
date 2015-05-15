%> @brief sostage - Spline Coefficients transformation
%>
%>
classdef sostage_fe_spline < sostage_fe
    methods
        function o = sostage_fe_spline()
            o.title = 'Spline';
        end;
    end;    
    
    methods(Access=protected)
        function out = do_get_block(o)
            out = fcon_spline();
            out.no_basis = o.nf;
        end;
        
        function s = get_blocktitle(o)
            s = [o.title, '(nf=', int2str(o.nf), ')'];
        end;
    end;
end
