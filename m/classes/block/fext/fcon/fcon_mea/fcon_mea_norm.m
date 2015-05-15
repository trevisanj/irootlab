%> @brief Norm
%>
%> @sa uip_fcon_mea_norm.m
classdef fcon_mea_norm < fcon_mea
    properties
        %> Whichever works with the \c norm() function
        type = 2;
    end;

    methods
        function o = fcon_mea_norm(o)
            o.classtitle = 'Norm';
        end;
    end;
    
    methods(Access=protected)
        function data = do_use(o, data)
            data.fea_x = 1;
            X = zeros(data.no, 1);
            for i = 1:data.no
                X(i, 1) = norm(data.X(i, :), o.type);
            end;
            data.X = X;
        end;
    end;
end
