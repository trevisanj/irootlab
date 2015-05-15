%> @brief Outlier removal by Kernel distribution estimation
%> @sa uip_blmisc_rowsout_kernel.m
classdef blmisc_rowsout_kernel < blmisc_rowsout_distr
    properties
        %> Kernel width as a percentage of the bin width
        kernelwidth = .1;
    end;
    
    properties(SetAccess=protected)
        distr_x;
        distr_y;
    end;
    
    methods
        function o = blmisc_rowsout_kernel(o)
            o.classtitle = 'Kernel';
        end;
    end;

    methods
        function o = calculate_ranges(o, data)
            o.ranges = [];
            o = o.calculate_distances(data);
            F = 50;
            wid = (max(o.distances)-min(o.distances))/o.no_bins*o.kernelwidth;
            [xa, ya] = distribution(o.distances, o.no_bins*F, [], wid);
            ya = ya/sum(ya)*numel(o.distances)*F;
            o.distr_x = xa;
            o.distr_y = ya;
            z = o.get_distrboolmap(ya);
            
            % Needs edges
            deltax = mean(diff(xa));
            edges = [xa-deltax/2, xa(end)+deltax/2];
%             edges = [xa xa(end)+deltax];
            
            flag_in = 0; % Inside a discarded range
            for i = 1:length(z)+1
                if flag_in && (i == length(z)+1 || z(i))
                    o.ranges(end+1, :) = [edges(ia), edges(i)];
                    flag_in = 0;
                elseif ~flag_in && i <= length(z) && ~z(i)
                    ia = i;
                    flag_in = 1;
                end;
            end;
        end;
        
        function o = draw_histogram(o)
            o = draw_histogram@blmisc_rowsout_uni(o);
            plot(o.distr_x, o.distr_y, 'Color', [151, 0, 112]/255, 'LineWidth', 3);
            hold on;
            o.draw_thresholds();
        end;
    end;
end

