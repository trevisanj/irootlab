%> @brief Select some given class levels.
%>
%> @sa uip_blmisc_classlabels_hierarchy.m, irdata
classdef blmisc_classlabels_hierarchy < blmisc_classlabels
    properties
        hierarchy = [];
    end;
    
    methods
        function o = blmisc_classlabels_hierarchy(o)
            o.classtitle = 'Select Class Levels';
        end;
    end;
    
    methods(Access=protected)
        function data2 = do_use(o, data)
            data2 = data_select_hierarchy(data, o.hierarchy);
        end;
    end;  
end

