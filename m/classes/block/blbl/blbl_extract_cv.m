%> @brief Extracts cluster vectors from block.
%> 
%> Generates a fcon_linear_fixed block whose loadings matrix is the cluster vectors of the input block.
%>
%> @sa data_get_cv.m, uip_blbl_extract_cv.m
classdef blbl_extract_cv < blbl
    properties
        idx_class_origin = 1;
        data;
    end;
    
    methods
        function o = blbl_extract_cv(o)
            o.classtitle = 'Extract Cluster Vectors';
            o.inputclass = {'fcon_linear', 'block_cascade_base'};
        end;
    end;
    
    methods(Access=protected)
        function oo = do_use(o, block)
            if block.flag_trainable > 0 && ~block.flag_trained
                irerror('Input block to blbl_extract_cv needs to be trained!');
            end;
            
            ob = fcon_linear_fixed();
            ob.L = data_get_cv(o.data, block.L, o.idx_class_origin);
            ob.L_fea_x = o.data.fea_x;
            ob.xname = o.data.xname;
            ob.xunit = o.data.xunit;
            ob.L_fea_names = o.data.classlabels;
            oo = ob;
        end;

    end;
end