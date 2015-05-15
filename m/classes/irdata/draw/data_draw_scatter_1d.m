%>@ingroup datasettools
%>@file
%>@brief Draws 1-D scatter plot with optional per-class distributions

%> @param data dataset
%> @param idx_fea What feature to use. Number points to 1 column in @c data.X
%> @param type_distr: controls drawing the distributions on top of the scores
%>  @arg @c 0 no distributions are drawn
%>  @arg @c 1 estimates distribution by gaussian kernel estimation (each point contributes with a small gaussian bump)
%>  @arg @c 2 histogram distribution estimation - each bar in the histogram represents a quantile, therefore has same area, therefore has variable width. Looks cool
%> @param threshold Works only for two classes. If specified, illustrates "misclassified" regions of each class
function data_draw_scatter_1d(data, idx_fea, type_distr, threshold)
global SCALE;

if ~exist('type_distr', 'var')
    type_distr = 1;
end;

flag_threshold = nargin > 3 && ~isempty(threshold);

if data.nc < 1
    pieces = data;
else
    pieces = data_split_classes(data);
end;
no_classes = size(pieces, 2);

idx_fea = idx_fea(1, 1);

if idx_fea > data.nf
    irerror(sprintf('Attempt to plot feature %d, but dataset has only %d feature(s)!', idx_fea, data.nf));
end;


% determines point range
xmin = +Inf;
xmax = -Inf;
for i = 1:no_classes
    mintemp = min(pieces(i).X(:, idx_fea(1)));
    maxtemp = max(pieces(i).X(:, idx_fea(1)));

    if mintemp < xmin
        xmin = mintemp;
    end;
    if maxtemp > xmax
        xmax = maxtemp;
    end;
end;


% First thing to draw is the threshold stuff: line and hachure
if flag_threshold
    if data.nc ~= 2
        irwarning('Dataset does not have two classes, threshold will be ignored');
    else
        flag_right = mean(pieces(1).X(:, idx_fea)) < mean(pieces(2).X(:, idx_fea));
        for i = 1:2
            
            % Hachures to mark "misclassified area"
            if flag_right
                draw_hachure([threshold, 3-i-0.1, xmax-threshold, 0.9]);
            else
                draw_hachure([xmin, 3-i-0.1, threshold-xmin, 0.9]);
            end;
            hold on;
            
            flag_right = ~flag_right;
        end;
        
        % Vertical line
        plot([1, 1]*threshold, [0.5, 3], 'LineWidth', scaled(3), 'LineStyle', '--', 'Color', [0, 0, 0]);
        hold on;
    end;
end;

switch type_distr
    case 1
        % Determines distribution multiplication factor. Classes with less points
        % will have a less high mountain. This gives a better visual feeling of the
        % outcome of a bayesian classifier.

        % I have dropped this because if there is a huge difference in number
        % of points between classes, the one with less points will have a
        % mountain which is too flat! Taking log() would make things more
        % presentable however wrong.

        if 0
            distrmult = zeros(1, no_classes);
            for i = 1:no_classes
                distrmult(i) = size(pieces(i).X, 1);
            end;

            if 0
                distrmult = log(distrmult);
            end;
            distrmult = distrmult/max(distrmult);
        else
            distrmult = ones(1, no_classes);
        end;
    case 2
end;
    
hh = [];
for i = 1:no_classes
    y_offset = no_classes+1-i;
    x = pieces(i).X(:, idx_fea(1));
    no_x = size(x, 1);
    if no_x <= 0
        % Just for the legend
        hh(end+1) = plot(1e-10, 0, 'Color', find_color(i), 'Marker', find_marker(i), 'LineStyle', 'none', 'MarkerSize', 10*SCALE, 'LineWidth', scaled(2));
        hold on;
        continue;
    end;

    no_quants = ceil(sqrt(no_x))+1;
    quants = linspace(0, 1, no_quants);
    quants = quants(2:end);


    y = y_offset*ones(no_x, 1); % zero 1-column vector


    % Histogram
    switch type_distr
        case 1
            [xdistr, ydistr] = distribution(x, 200);
            ydistr = distrmult(i)*ydistr/max(ydistr)*.75;
            plot(xdistr, ydistr+y_offset+.05, 'Color', [1, 1, 1]*.4, 'LineWidth', scaled(2));
            hold on;
        case 2
            xsorted = sort(x);
            I = (1:length(xsorted))/length(xsorted);

            % attempt 2 (good but uses the spline toolbox)
            w = ones(1, length(I)); w([1, end]) = 300;
            sp = spaps(I, xsorted, 1e-15, w, 1);  % perfect!!!
            t = fnval(sp, quants);
            t = [xsorted(1) t];


    %             t = quantile_landmarks(integrate(x), no_quants, [min(x), max(x)]);
            tdiff = diff(t);
            [hmult, idx] = min(tdiff);

            for j = 1:no_quants

                % This logic here finds bar widths at both sides of the current point
                for k = 1:2
                    if j == 1
                        if k == 2
                            wleft = wright;
                        end;
                    else
                        wleft = t(j)-t(j-1);
                    end;

                    if k == 1
                        if j == no_quants
                            wright = wleft;
                        else
                            wright = t(j+1)-t(j);
                        end;
                    end;
                end;


                t1 = t(j)-wleft/2;
                t2 = t(j)+wright/2;
                v1 = [t1, t2, t2, t1, t1];
                if t2-t1 > 0
                    h = 1/(t2-t1)*hmult;
                else
                    h = 1;
                end;
                h = h*.75;
                v2 = [0, 0, h, h, 0]+y_offset+.05;

                plot(v1, v2, 'Color', [1, 1, 1]*.4, 'LineWidth', scaled(2));
                hold on;
            end;
    end;


    hh(end+1) = plot(x, y, 'Color', find_color(i), 'Marker', find_marker(i), 'LineStyle', 'none', 'MarkerSize', 10*SCALE, 'LineWidth', scaled(2));
    hold on;
    plot(mean(x(:)), y(1), 'Color', find_color(i), 'Marker', find_marker(i), 'LineWidth', scaled(3), 'MarkerSize', 15*SCALE);
end


extent = xmax-xmin;
k = 0.05;
xmin = xmin-extent*k;
xmax = xmax+extent*k;
if xmin == xmax
    xmax = xmax+.001; % This is just an error prevention when there is no scatter at all.
    xmin = xmin-.001;
end;
set(gca(), 'XLim', [xmin, xmax]);
% xmaxabs = max(abs([xmin, xmax]));
% set(gca(), 'XLim', [-xmaxabs, xmaxabs]);

set(gca(), 'YTick', [])
set(gca(), 'YLim', [0.5 no_classes+1]);

feanames = data.get_fea_names(idx_fea);
xlabel(feanames{1});

legend(hh, data_get_legend(data));
format_frank([], SCALE);
