%> 2ndpass - must write a design here soon
%>
%> @brief sostage - PCA
%>
%> In this Feature Extraction stage, the design consists of determining the best number of factors. Factors are added sequentially (there is
%> no "factor selection")
%>
%>
classdef sostage_fe_pca < sostage_fe
    methods
        function o = sostage_fe_pca()
            o.title = 'PCA';
        end;
    end;    
    
    methods(Access=protected)
        function out = do_get_block(o)
            out = fcon_pca();
            out.no_factors = o.nf;
        end;
    end;
end
