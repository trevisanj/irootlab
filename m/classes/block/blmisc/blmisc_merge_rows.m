%> @brief Merges datasets serially (row-wise).
%>
%> All datasets must have same \ref nf, and the variables (features) must have same meanings and units.
classdef blmisc_merge_rows < blmisc_merge
    properties
        hierarchy = [];
    end;
    
    methods
        function o = blmisc_merge_rows(o)
            o.classtitle = 'Row-wise';
        end;
    end;
    
    methods(Access=protected)
        function data = do_use(o, datasets)
            data = data_merge_rows(datasets);
        end;
    end;  
end

