%> @brief Polynomial Baseline Correction
%>
%> Algorithm is implemented in data-independent bc_poly.m
%>
%> @sa bc_poly.m, uip_pre_bc_poly.m
classdef pre_bc_poly < pre_bc
    properties
        %> =5. See bc_poly.m
        order = 5;
        %> =[] (auto). See bc_poly.m
        epsilon = [];
        contaminant_data = [];
        contaminant_idxs = [];
    end;

    
    methods
        function o = pre_bc_poly(o)
            o.classtitle = 'Polynomial';
        end;
    end;
    
    methods(Access=protected)
        
        %> Applies block to dataset
        function data = do_use(o, data)
            if ~isempty(o.contaminant_data)
                X = o.contaminang_data.X(o.idxs, :);
            else
                X = [];
            end;

            data.X = bc_poly(data.X, o.order, o.epsilon, X);
        end;
    end;
    
end