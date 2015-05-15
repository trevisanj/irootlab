%> @brief Sorts dataset class labels renumbering classes accordingly.
classdef blmisc_classlabels_sort < blmisc_classlabels
    properties
        hierarchy = [];
    end;
    
    methods
        function o = blmisc_classlabels_sort(o)
            o.classtitle = 'Sort';
            o.flag_params = 0;
        end;
    end;
    
    methods(Access=protected)
        function data = do_use(o, data)
            data = data_sort_classlabels(data);
        end;
    end;  
end

