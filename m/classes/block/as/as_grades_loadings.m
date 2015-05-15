%> @brief Loadings vector becomes the grades vector
%>
%> Trains a @ref fcon_linear block (or a @ref block_cascade) to extract one of its loadings vector.
%>
classdef as_grades_loadings < as_grades
    properties
        %> @ref fcon_linear block to calculade loadings
        fcon_linear;
        %> =1. Which loadings vector to use. 1 makes sense in most cases.
        idx_loadings = 1;
    end;
    
    methods
        function o = as_grades_loadings()
            o.classtitle = 'Loadings';
            o.flag_ui = 0;
        end;
    end;
    
    methods(Access=protected)
        function out = do_use(o, data)
            da1 = data(1);

            blk = o.fcon_linear.boot();
            blk = blk.train(da1);

            out = log_grades();
            out.grades = abs(blk.L(:, o.idx_loadings))';
            out.fea_x = da1.fea_x;
            out.xname = da1.xname;
            out.xunit = da1.xunit;
            out.yname = blk.get_description;
        end;
    end;   
end
