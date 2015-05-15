%> @brief Base class for optimizations of parameters of a linear transformation
%>
classdef sostage_fe_linear < sostage_fe
    methods
        function s = get_blocktitle(o)
            s = [o.title, '(nf=', int2str(o.nf), ')'];
        end;
    end;
end
