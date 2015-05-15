%> @brief Randomizes classes.
%>
%> Number of classes remains the same, but uniform distribution (same probability for each class), regardless of the
%> class prior distribution.
classdef blmisc_classes_random < blmisc_classes
    properties
        classlabels_new;
    end;
    
    methods
        function o = blmisc_classes_random(o)
            o.classtitle = 'Randomize';
            o.flag_params = 0;
        end;
    end;
    
    methods(Access=protected)
        function data = do_use(o, data)
            data.classes = floor(rand(data.no, 1)*data.nc-.00000000001);
        end;
    end;  
end

