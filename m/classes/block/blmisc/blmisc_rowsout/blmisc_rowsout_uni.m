%> @brief Univariate Outlier removal
%>
%> This block generates two datasets. The first one contains the inliers and the second one the outliers.
%> The inlier is derived at training stage. \c train() and \c use() don't need to be called with the same dataset, but
%> the datasets do need to have the same number of rows.
classdef blmisc_rowsout_uni < blmisc_rowsout
    properties(SetAccess=protected)
        distances = [];
        hits = [];
        edges = [];
    end;
    
    properties
        %> =1. Index of feature to consider
        idx_fea = 1;
        %> Number of bins for histogram calculation.
        no_bins = 100;
        %> [no_ranges][2] matrix. Univariate outlier removal is range-based. Descendants may have different ways to fill in this property.
        ranges = [];
    end;
    
    methods
        function o = blmisc_rowsout_uni(o)
            o.classtitle = 'Univariate';
        end;
    end;
      
    methods
        %. @brief Returns the index of the first bin that already starts above the 50%
        function z = get_idx_50plus(o, x)
            I = integrate(x);
            [val, idx] = find(I > I(end)/2);
            z = idx(1);
        end;
       
        function o = calculate_map(o, data)
            o = o.calculate_ranges(data);
            boolmap = ones(1, length(o.distances));
            for i = 1:size(o.ranges, 1)
                boolmap = boolmap & ~((o.distances >= o.ranges(i, 1)) & (o.distances < o.ranges(i, 2)));
            end;
            o.map = find(boolmap);
        end;

        function o = calculate_distances(o, data)
            if data.no > 0
                o.distances = data.X(:, o.idx_fea)';
            else
                o.distances = [];
            end;
        end;
        
        %> Abstract.
        function o = calculate_ranges(o, data)
        end;
        
        %> @brief Calculates @c edges and @c hist properties. Dependant on calling @c calculate_distances() first.
        function o = calculate_hits(o)
            if isempty(o.distances)
                o.hits = [];
                o.edges = [];
            else
                maxdist = max(o.distances);
                mindist = min(o.distances);
                offset = (maxdist-mindist)*.00001;
                o.edges = linspace(mindist-offset, maxdist+offset, o.no_bins+1);
                o.hits = histc(o.distances, o.edges);
                o.hits = o.hits(1:end-1); % For some reason histc always places a zero element at the end
            end;
        end;
        
        %> Draws hachures do signal ranges, and histogram
        function o = draw_histogram(o)
            o = o.calculate_hits();
            if ~isempty(o.hits)
                
                % Replaces infinities in ranges
                ra = o.ranges;
                di = o.edges(2)-o.edges(1);
                ra(ra == -Inf) = o.edges(1)-di;
                ra(ra == +Inf) = o.edges(end)+di;
                
                x = sum([o.edges(1:end-1); o.edges(2:end)], 1)/2;
                maxy = max(o.hits)*1.1;

                for i = 1:size(ra, 1)
                    if ra(i, 2) > ra(i, 1)
                        draw_hachure([ra(i, 1), 0, ra(i, 2)-ra(i, 1), maxy]);
                    else
                        % ignores in drawing
                    end;
                    hold on;
                end;

                bar(x, o.hits, 'FaceColor', [.3, .3, 1]);
                hold on;

                xlim([o.edges(1), o.edges(end)]);
                ylim([0, maxy]);
                format_frank();
            end;
        end;
    end;
end

