%> @brief "Super-object" encapsulating both a @ref as_fsel_grades and a @ref as_grades_data object
%>
%> This class allows the input to be a dataset (@ref irdata) instead of a @ref log_grades
%>
%> @arg The @ref as_grades_data object calculates the grades vector, whereas ...
%> @arg the @ref as_fsel_grades performs itself the feature selection.
classdef as_fsel_grades_super < as_fsel
    properties
        %> @ref as_grades_data object
        as_grades_data;
        
        %> @ref as_fsel_grades object
        as_fsel_grades;
    end;
    
    properties(Dependent)
        %> Number of features to be selected
        nf_select;
    end;
    
    methods
        function o = as_fsel_grades_super()
            o.classtitle = 'Grades super-object';
            o.flag_ui = 0;
        end;
        
        function n = get.nf_select(o)
            n = NaN;
            if ~isempty(o.as_fsel_grades)
                n = o.as_fsel_grades.nf_select;
            end;
        end;
        
        function o = set.nf_select(o, n)
            if ~isempty(o.as_fsel_grades)
                o.as_fsel_grades.nf_select = n;
            end;
        end;
    end;        
    
    methods(Access=protected)
        function log2 = do_use(o, data)
            log1 = o.as_grades_data.use(data);
            log2 = o.as_fsel_grades.use(log1);
        end;
    end;
end
