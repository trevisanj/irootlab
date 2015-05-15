%> @ingroup graphicsapi
%> @file
%> @brief Generates a colormap from an integer vector of classes.
%>
%> @brief Functions to draw plots and images based on values and axis data from a @ref sovalues object
classdef plotter12
    properties
        %> 2D Structure array with fields varying
        values;

        %> 2-element Array of axisdata objects
        ax = raxisdata.empty();
        
        flag_hachure = 0;
    end;
    
    methods
        %> Draws single plot with many lines
        %> @param name ='rates'. 'rates'/'times1'/'times2'/'times3' etc
        %> @param flag_legend =1. (Legends will be ax(2).legends)
        %> @param ylimits =(automatically calculated by MATLAB)
        %> @param xticks =(taken from the @ref ax property)
        %> @param xticklabels=(taken from the @ref ax property)
        function draw_plot(o, name, flag_legend, ylimits, xticks, xticklabels, star_ii)
            if nargin < 2 || isempty(name)
                name = 'rates';
            end;
            
            if nargin < 3 || isempty(flag_legend)
                flag_legend = 1;
            end;
            
            flag_autoylim = 1;
            if nargin >= 4 && ~isempty(ylimits)
                flag_autoylim = 0;
            end;
            
            if nargin < 5 || isempty(xticks)
                xticks = o.ax(1).values;
            end;
            
            if nargin < 6 || isempty(xticklabels)
                xticklabels = o.ax(1).ticks;
            end;
            
            flag_star = 1;
            if nargin < 7 || isempty(star_ii)
                flag_star = 0;
            end;

            D = o.get_Y(name);
            [nfe, nar, fold] = size(D);

            nfs = o.ax(1).values;
            
            if length(nfs) > nfe % This is a hack because I was saving results wrongly!
                nfs = nfs(1:nfe);
            end;

%             y = o.get_y(name);
            
%             nar = size(y, 2);

            for j = 1:nar
                X = reshape(D(:, j, :), [nfe, fold]); % matrix [nfe]x[number of folds in cross-validation]

                for m = 1:size(X, 1)
                    ci(1:2, m) = confint(X(m, :))'; % Calculates confidence intervals
                    me(m) = mean(X(m, :));
                end;

                if o.flag_hachure
                    draw_hachure2(nfs, ci, find_color(j));
                    hold on;
                end;


                try
                    hl(j) = plot(nfs(:), me, 'Color', find_color(j), 'LineStyle', find_linestyle(j), 'Linewidth', scaled(3), 'Marker', find_marker(j), 'MarkerSize', find_marker_size(j));
                catch ME
                    disp('tentando descobrir a merda no FRANK-PC');
                    rethrow(ME);
                end;
                hold on;
                
                if flag_star
                    plot(nfs(star_ii(j)), me(star_ii(j)), 'p', 'LineWidth', scaled(2.5), 'MarkerSize', scaled(25), 'Color', find_color(j));
                end;
                
            end;
            if length(nfs) > 1
                xl = nfs([1, end]);
                xlim(xl);
            end;
            xlabel(o.ax(1).label);
            ylabel(labeldict(name));
            if flag_legend
                legend(hl, o.ax(2).legends);
            end;
            if ~flag_autoylim
                ylim(ylimits);
            end;
            set(gca, 'XTick', xticks);
            set(gca, 'XTickLabel', xticklabels);
            decimate_ticks([1, 0]);
            box off;
            format_frank();
%             maximize_window();
%             set(gca, 'Position', [0.0661    0.0927    0.8953    0.8382]); % Empirical
            make_box();
        end;
        

        %> Draws a single figure with several subplots.
        %>
        %> Each subplot corresponds to a different architecture.
        %>
        %> @param name ='rates'. 'rates'/'times1'/'times2'/'times3' etc
        %> @param ylimits =(automatically calculated by MATLAB for each individual subplot)
        %> @param xticks =(taken from the @ref ax property)
        %> @param xticklabels=(taken from the @ref ax property)
        function draw_subplots(o, name, ylimits, xticks, xticklabels, star_ii)
            
            if nargin < 2 || isempty(name)
                name = 'rates';
            end;

            D = o.get_Y(name);
            [nfe, nar, fold] = size(D);

            nfs = o.ax(1).values;
            if length(nfs) > nfe % This is a hack because I was saving results wrongly!
                nfs = nfs(1:nfe);
            end;

            
            flag_autoylim = 1;
            if nargin >= 3 && ~isempty(ylimits)
                flag_autoylim = 0;
            end;
            
            if nargin < 4 || isempty(xticks)
                xticks = nfs;
            end;

            if nargin < 5 || isempty(xticklabels)
                xticklabels = o.ax(1).ticks;
            end;
            
            flag_star = 1;
            if nargin < 6 || isempty(star_ii)
                flag_star = 0;
            end;
            


            % Determines number of plot rows and columns
            w = ceil(sqrt(nar)); % number of columns (Width)
            h = ceil(nar/w); % number of rows (Height)
            
            % Spacings and margins are sensitive to the number of plot rows
            % and columns
            
            hwref = max(w/4, h/3);
            
            kw = (7-hwref*4)/3;
            kh = (5-hwref*3)/2;
            
            MLEF = .06*kw;
            MRIG = 0.02*kw;
            MTOP = .05*kh;
            MBOT = .08*kh;
            XSPACING = .05*kw;
            YSPACING = .1*kh;
            
            subw = (1-XSPACING*(w-1)-MLEF-MRIG)/w;
            subh = (1-YSPACING*(h-1)-MTOP-MBOT)/h;            
            
            
            
            y0 = MBOT+(subh+YSPACING)*(h-1);
            
            k = 0;
            for i = 1:h
                x0 = MLEF;
                for j = 1:w
                    k = k+1;
                    if k > nar
                        break;
                    end;
                    
                    subplot('Position', [x0, y0, subw, subh]); %h, w, k);
                    
                    X = reshape(D(:, k, :), [nfe, fold]); % matrix [nfe]x[number of folds in cross-validation]
                        
                    for m = 1:size(X, 1)
                        ci(1:2, m) = confint(X(m, :))'; % Calculates confidence intervals
                        me(m) = mean(X(m, :));
                    end;
                    
                    if o.flag_hachure
                        draw_hachure2(nfs, ci, find_color(k));
                        hold on;
                    end;
                    
                    plot(nfs, me, 'Color', find_color(k), 'LineStyle', find_linestyle(k), 'Linewidth', scaled(3), 'Marker', find_marker(k), 'MarkerSize', find_marker_size(k));
                    hold on;

                    
                    if flag_star
                        plot(nfs(star_ii(k)), me(star_ii(k)), 'p', 'LineWidth', scaled(2.5), 'MarkerSize', scaled(25), 'Color', find_color(k));
                    end;
                    
% % % % % %                     if i == h
% % % % % %                         xlabel('Number of features');
% % % % %                         set(gca, 'xtick', xticks);
% % % % % %                     end;
% % % % % %                     ylabel('');
                    
                    if ~flag_autoylim
                        ylim(ylimits);
                    end;
                    set(gca, 'XTick', xticks);
                    set(gca, 'XTickLabel', xticklabels);
                    if length(nfs) > 1
                        xl = nfs([1, end]);
                        xlim(xl);
                    end;                    
                    decimate_ticks([1, 0]);

                    
                    title(o.ax(2).legends{k}, 'FontWeight', 'bold');
                    format_frank();
                    make_box();
                    
                    x0 = x0+(subw+XSPACING);
                end;
                y0 = y0-(subh+YSPACING);
            end;
            
            global FONT FONTSIZE;
            
            if h == 1 && w == 1
                % If there is one plot only, uses MATLAB's default x- and
                % y-labels
                xlabel(o.ax(1).label);
                ylabel(labeldict(name));
                set(gca, 'Position', [0.0661    0.0927    0.8953    0.8382]); % Empirical                
            else
                % Vertical label (e.g. "Classification rate (%)")
                subplot('Position', [0, 0, MLEF*.8, 1]);
                axis off;
                text('Position', [0.5, 0.5, 0], ...
                          'Rotation', 90, ...
                          'HorizontalAlignment', 'center', ...
                          'VerticalAlignment', 'middle', ...
                          'FontName', FONT, ...
                          'FontSize', scaled(FONTSIZE), ...
                          'String', labeldict(name));

                % Vertical label (e.g. "Classification rate (%)")
                subplot('Position', [MLEF, 0, 1-MLEF, MBOT*0.8]);
                axis off;
                text('Position', [0.5, 0.5, 0], ...
                          'Rotation', 0, ...
                          'HorizontalAlignment', 'center', ...
                          'VerticalAlignment', 'middle', ...
                          'FontName', FONT, ...
                          'FontSize', scaled(FONTSIZE), ...
                          'String', o.ax(1).label);
            end;
            
            maximize_window();
        end;
        

        %> Draws each value as an image pixel
        %>
        %> For the colors:
        %> @arg it may use the whole colormap range (don't specify the @c clim parameter), or
        %> @arg make the colormap span the range specificed by @c clim (and the values will probably be contained within a subrange
        %> thereof). This case is useful for when you want to draw several images and compare them using the same "color scale"
        %>
        %> @param name ='rates'. 'rates'/'times1'/'times2'/'times3' etc
        %> @param star_ij (optional) Row and Column of the "best", to put a STAR on. If not specified, no star is drawn
        %> @param clim =[] see description above
        %> @param flag_logtake =0 Whether to take logarithm of values (useful
        %> for SVM time images
        function o = draw_image(o, name, star_ij, clim, flag_logtake, flag_transpose)
            
            if nargin < 2 || isempty(name)
                name = 'rates';
            end;
            
            flag_star = 1;
            if nargin < 3 || isempty(star_ij)
                flag_star = 0;
            end;
            
            flag_clim = 1;
            if nargin < 4 || isempty(clim)
                flag_clim = 0;
            end;
            
            if nargin < 5 || isempty(flag_logtake)
                flag_logtake = 0;
            end;

            if nargin < 6 || isempty(flag_transpose)
                flag_transpose = 0;
            end;
            
            
            
            Z = o.get_y(name);

            a1 = 1;
            a2 = 2;
            if flag_transpose
                a1 = 2;
                a2 = 1;
                [ny, nx] = size(o.values);
                Z = Z';
            else
                [nx, ny] = size(o.values);
            end;

            xx = 1:nx; % x ticks
            yy = 1:ny; % y ticks

            
            if flag_logtake
                if flag_clim
                    clim = log10(clim);
                end;
                Z = log10(Z);
            end;
            
            if flag_clim
                set(gca, 'CLim', clim);
                image(xx, yy, Z', 'CDataMapping', 'scaled');
                set(gca, 'CLim', clim);
            else
                imagesc(xx, yy, Z');
            end;
            axis image;
            hold on;


            xlabel(o.ax(a1).label);
            ylabel(o.ax(a2).label);
            
            set(gca, 'XTick', xx, 'YTick', yy, 'XTickLabel', o.ax(a1).ticks, 'YTickLabel', o.ax(a2).ticks);
            decimate_ticks([1, 1], [13, 13]);


            % THis is disabled because one these "ticks" are put, they cannot be removed by xtick([])
            % rotateticklabel(gca, 90);

            if flag_star
                plot3(star_ij(a1), star_ij(a2), 0.1, 'pk', 'LineWidth', scaled(2), 'MarkerSize', scaled(15));
            end;
            h = colorbar;
            format_frank([], [], h);
            decimate_ticks([], [7, 13]);
            make_box(); % This is image, makebox maybe not
        end;
    end;
    
    
    % Lower-level stuff        
    methods
        %> Mounts a matrix containing the averages of a field within the "values" property specified by the "name" parameter
        function y = get_y(o, name)
            [ni, nj] = size(o.values);

            for i = 1:ni
                for j = 1:nj
                    y(i, j) = mean(o.values(i, j).(name));
                end;
            end;
        end;

        
        %> Mounts a matrix containing the values of a field within the "values" property specified by the "name" parameter
        function Y = get_Y(o, name)
            [ni, nj] = size(o.values);

            for i = 1:ni
                for j = 1:nj
                    Y(i, j, :) = o.values(i, j).(name); %#ok<*AGROW>
                end;
            end;
        end;
    end;
end
