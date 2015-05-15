%> @brief 1D Scatterplot with x-axis values associated to classes and curve fit
%>
%> @sa uip_vis_curvefit.m
classdef vis_curvefit < vis
    properties
        idx_fea = 1;
        flag_ud = 0;
        flag_abs = 0;
        conc = [];
    end;
    
    methods
        function o = vis_curvefit(o)
            o.classtitle = '"Build Curves"';
            o.inputclass = 'irdata';
        end;
    end;
    
    methods(Access=protected)
        function out = do_use(o, data)
            out = [];

            if length(o.conc) ~= data.nc
                irerror(sprintf('Concentration vector and data classes don''t match cardinality (which are respectively %d and %d)', length(o.conc), data.nc));
            end;
            
            % Sorts concentrations
            x = o.conc;
            temp = [x' (1:data.nc)'];
            temp = sortrows(temp);
            indexes = temp(:, 2)';
            x = temp(:, 1)';


            data = data.select_features(o.idx_fea);
            if o.flag_ud
                data.X = -data.X;
            end;

            % Extracts class means
            pieces = data_split_classes(data);
            mean_control = mean(pieces(indexes(1)).X(:, 1));
            irverbose(sprintf('* Mean "%s": %g', pieces(indexes(1)).classlabels{1}, mean_control), 1);
            y = zeros(1, data.nc);
            for i = 2:data.nc
            %    y(i) = abs(mean(pieces(indexes(i)).X(:, 1))-mean_control);
                y(i) = mean(pieces(indexes(i)).X(:, 1))-mean_control;
                if o.flag_abs
                    y(i) = abs(y(i));
                end;
                irverbose(sprintf('* Mean "%s": %g', pieces(indexes(i)).classlabels{1}, y(i)), 1);
            end;

            % Curve fit
            % p = polyfit(x, y, data.nc-4);
            % yp = polyval(p, xp);
            x_ =log10(x(2:end));
            y_ = y(2:end);
            xp_ = linspace(log10(x(2)), log10(x(data.nc)), 100);

            yp_ = spline(x_, y_, xp_);


            % Now starts plotting
            plot(xp_, yp_, 'k', 'LineWidth', 4);
            hold on;

            for i = 2:data.nc
                v = pieces(indexes(i)).X(:, 1);
                v = v-mean(v)+y(i);
                plot(x_(i-1)*ones(length(v), 1), v, 'Color', find_color(indexes(i)), 'Marker', find_marker(indexes(i)), 'MarkerSize', 10, 'LineStyle', 'none', 'LineWidth', 2);
            end;


            plot(x_, y_, 'ks', 'MarkerFaceColor', 'k', 'MarkerSize', 20);
            for i = 1:data.nc-1
                text(x_(i)+.13, y_(i), sprintf('%g', x(i+1)), 'FontSize', 25);
            end;
            % set(gca, 'XLim', [x_(1)-.00001, x_(end)+.00001]);
            set(gca, 'XLim', [x_(1)-.25, x_(end)+.25]);
            xlabel('log_{10}(Concentration)');
            ylabel('Distance from reference class');
            %title('Effect curve');
            set_title(o.classtitle, data);
            format_frank();
            make_box();
        end;
    end;
end
