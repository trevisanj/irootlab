%> @brief Merges datasets parallelly (column-wise).
%>
%> Needless say, datasets must have same \ref no, and be representations of the same physical data.
classdef blmisc_merge_cols < blmisc_merge
    properties
        hierarchy = [];
    end;
    
    methods
        function o = blmisc_merge_cols(o)
            o.classtitle = 'Column-wise';
        end;
    end;
    
    methods(Access=protected)
        function data = do_use(o, datasets)
            data = data_merge_cols(datasets);
        end;
    end;  
end

