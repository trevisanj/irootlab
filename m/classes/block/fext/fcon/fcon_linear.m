%> @brief Feature Construction - Linear Transformations base class
classdef fcon_linear < fcon
    properties
        %> Prefix for the factos space variables, e.g., "PC", "LD"
        L_fea_prefix = 'LIN';
        %> Names of the factors!
        L_fea_names = [];
        %> Loadings vector
        L = [];
        %> Loadings x-axis (in this case, the up-to-down dimension)
        L_fea_x;
        %> Name of loadings x-axis
        xname;
        xunit;
    end;

    
    methods
        function o = fcon_linear()
            o.classtitle = 'Linear Transformation';
        end;
        
        function a = get_L_fea_names(o, idxs)
            if ~isempty(o.L_fea_names)
                if any(idxs > numel(o.L_fea_names))
                    ii = find(idxs > numel(o.L_fea_names));
                    irerror(sprintf('L_fea_names size %d < %d', numel(o.L_fea_names), idxs(ii(1))));
                end;
                a = o.L_fea_names(idxs);
            else
                if ~isempty(o.L_fea_prefix)
                    prefix = o.L_fea_prefix;
                else
                    prefix = 'Factor ';
                end;
                a = arrayfun(@(x) [prefix, int2str(x)], idxs, 'UniformOutput', 0);
            end;
        end;
    end;
    
    methods(Access=protected)
        function data = do_use(o, data)
            data = data.transform_linear(o.L, o.L_fea_prefix);
        end;
    end;
end
