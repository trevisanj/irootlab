%> @brief Representation of a Unit
%> @ingroup graphicsapi
%>
%> @sa bmtable
classdef bmunit < irobj
    properties
        peakdetector;
        %> ='%g'. @c sprintf() rendering format for numbers.
        yformat = '%g';
        %> =0. Whether to draw a Zero Line, usually true for units that assume negative and positive values.
        flag_zeroline = 0;
        %> =0. Whether the Zero should be included in the range.
        flag_zero = 0;
        %> =0. Whether to plot as histogram
        flag_hist = 0;
    end;
    
    methods
        function o = bmunit()
            o.classtitle = 'Unit';
        end;
    end;
end
