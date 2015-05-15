%> @brief Re-sets the x-axis of a dataset using 2-element range vector provided.
%>
%>
classdef blmisc_fearange < blmisc
    properties
        %> 2-element vector containing what are supposed to be the first and last elements of the x-axis vector of the
        %> dataset. The class is prepared to handle both the direct and reverse cases.
        range;
    end;
    
    methods
        function o = blmics_fearange(o)
            o.classtitle = 'Re-set x-axis';
            o.flag_params = 1;
        end;
    end;
    
    methods(Access=protected)
        function data = do_use(o, data)
            data.fea_x = linspace(o.range(1), o.range(2), data.nf);
        end;
    end;  
end

