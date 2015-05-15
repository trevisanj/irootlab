%> @brief Calculates grades using a Feature Subset Grader (FSG) object
classdef as_grades_fsg < as_grades
    properties
        %> Feature Subset Grader (FSG) object
        fsg;
    end;
    
    methods
        function o = as_grades_fsg()
            o.classtitle = 'Using FSG';
        end;
    end;
    
    methods(Access=protected)
        function out = do_use(o, data)
            da1 = data(1);
            idxs = num2cell(1:da1.nf);
            o.fsg.data = da1;
            o.fsg = o.fsg.boot();
            gradestemp = o.fsg.calculate_grades(idxs);

            out = log_grades();
            out.grades = gradestemp(:, :, 1); % It is possible that an SGS object in the FSG will have 3 or more bites
            out.fea_x = da1.fea_x;
            out.xname = da1.xname;
            out.xunit = da1.xunit;
            out.yname = o.fsg.classtitle;
            out.yunit = '';
        end;
    end;
end
