%> @brief Distribution-Based Outlier Removal
%>
%> @sa uip_blmisc_rowsout_distr.m
classdef blmisc_rowsout_distr < blmisc_rowsout_uni  
    properties
        %> =0.01. Value to be used if type is \c 'threshold'. This is a
        %> fraction of the maximum value in the histogram
        threshold = 0.01;
        %> =0. Range filter: 0-none; 1-left quantile; 2-right quantile
        quantile = 0;
        %> =0. Activates "tail trimming mode". In this mode, tails are trimmed starting at the first bin below the
        %> threshold. This can happen either/both at the first or/and second quantile, depending on the value of the @c
        %> quantile property.
        flag_trim_tail = 0;
    end;
    
    methods
        function o = blmisc_rowsout_distr(o)
            o.classtitle = 'Distribution Estimation';
        end;

        function o = draw_histogram(o)
            draw_histogram@blmisc_rowsout_uni(o);
            o.draw_thresholds();
        end;
        
        %> @brief Returns a vector that flags whether each bin goes or not.
        function z = get_distrboolmap(o, x)
            nb = length(x); % number of bins
            z = ones(1, nb);
            v = 1:nb;
            i1 = 1; 
            i2 = nb;
            iq = o.get_idx_50plus(x);
            if o.quantile == 1 % restricts check to quantile
                i2 = iq-1;
            elseif o.quantile == 2
                i1 = iq;
            end;
            absthreshold = o.threshold*max(x);
            for i = i1:i2
                if x(i) < absthreshold
                    if o.flag_trim_tail
                        if i < iq
                            z(v <= i) = 0;
                        else
                            z(v >= i) = 0;
                        end;
                    else
                        z(i) = 0;
                    end;
                end;
            end;
        end
    end;
    
    methods(Access=protected)
        function o = draw_thresholds(o)
            x1 = o.edges(1);
            x2 = o.edges(end);
            maxy = max(o.hits)*1.1;
            if o.quantile == 1 % left quantile
                x2 = o.edges(o.get_idx_50plus(o.hits));
                plot([x2, x2], [0, maxy], 'r', 'LineWidth', 2);
                hold on;
            elseif o.quantile == 2 % right quantile
                x1 = o.edges(o.get_idx_50plus(o.hits));
                plot([x1, x1], [0, maxy], 'r', 'LineWidth', 2);
                hold on;
            end;
            plot([x1, x2], [1, 1]*o.threshold*max(o.hits), 'r', 'LineWidth', 2);
            hold on;
        end;
    end;        
end

