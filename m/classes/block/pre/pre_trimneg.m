%> @brief Trim Negatives to zero
%>
%> Forces any negative value to zero
classdef pre_trimneg < pre
    
    methods
        function o = pre_trimneg(o)
            o.classtitle = 'Trim Negatives';
            o.flag_params = 0;
        end;
    end;
    
    methods(Access=protected)
        % Applies block to dataset
        function data = go_use(o, data)
            data.X(data.X < 0) = 0;
        end;
    end;
end