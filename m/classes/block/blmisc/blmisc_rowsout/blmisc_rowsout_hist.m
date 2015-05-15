%> @brief Outlier removal by Histogram
%> @sa uip_blmisc_rowsout_hist.m
classdef blmisc_rowsout_hist < blmisc_rowsout_distr
    methods
        function o = blmisc_rowsout_hist(o)
            o.classtitle = 'Histogram';
        end;
    end;

    methods
        function o = calculate_ranges(o, data)
            o.ranges = [];
            o = o.calculate_distances(data);
            o = o.calculate_hits();
            z = o.get_distrboolmap(o.hits);
            flag_in = 0; % Inside a discarded range
            for i = 1:length(z)+1
                if flag_in && (i == length(o.hits)+1 || z(i))
                    o.ranges(end+1, :) = [o.edges(ia), o.edges(i)];
                    flag_in = 0;
                elseif ~flag_in && i <= length(o.hits) && ~z(i)
                    ia = i;
                    flag_in = 1;
                end;
            end;
        end;
    end;
end

