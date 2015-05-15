%> @brief Renames class labels.
%>
%> There should be no duplicate names and number of levels should remain the same.
%>
%> @sa uip_blmisc_classlabels_rename.m
classdef blmisc_classlabels_rename < blmisc_classlabels
    properties
        classlabels_new;
    end;
    
    methods
        function o = blmisc_classlabels_rename(o)
            o.classtitle = 'Rename';
        end;
    end;
    
    methods(Access=protected)
        function data = do_use(o, data)
            if length(o.classlabels_new) ~= length(data.classlabels)
                irerror('New class label must have same number of elements!');
            end;
            
            nl = data.get_no_levels();

            data.classlabels = o.classlabels_new;
            
            % Uses the following function with full-level selection in order to condense eventual repetitions in the class labels
            data = data_select_hierarchy(data, 1:data.get_no_levels());
        end;
    end;  
end

