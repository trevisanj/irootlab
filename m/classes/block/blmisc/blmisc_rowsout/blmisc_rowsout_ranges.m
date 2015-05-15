%> @brief Outlier removal by Ranges
%>
%> @sa uip_blmisc_rowsout_ranges.m
classdef blmisc_rowsout_ranges < blmisc_rowsout_uni
    methods
        function o = blmisc_rowsout_ranges(o)
            o.classtitle = 'Ranges';
        end;
        
        function o = calculate_ranges(o, data)
            o = o.calculate_distances(data);
        end;
    end;
end

