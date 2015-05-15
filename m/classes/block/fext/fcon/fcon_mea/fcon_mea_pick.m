%> @brief Picks region area, region peak, or value at fixed x-position
classdef fcon_mea_pick < fcon_mea
    properties
        %> ='f'. What to pick:
        %> @arg <code>'f'</code> Value at fixed x-position
        %> @arg <code>'m'</code> Maximum within range
        %> @arg <code>'a'</code> Area within range
        %>
        %> 'm' and 'a' types require two elements in fcon_mea_pick::v
        type = 'f';
        
        %> location/range vector, given in x-axis units
        v = [];
    end;
    
    methods
        function o = fcon_mea_pick(o)
            o.classtitle = 'Various';
            o.flag_params = 1;
        end;

        function o = illustrate(o, data, obsidx)
            global SCALE;

            
            vidx = v_x2ind(o.v, data.fea_x);

            % Validates vector
            if o.type == 'f' || o.type == 'm'
                if numel(o.v) < 2
                    irerror('Please supply a 2-element wavenumbers vector!');
                end;
                
                if vidx(1) > vidx(2)
                    irerror('It seems that the vector elements are in inverted order!');
                end;
            else
                if numel(o.v) < 1
                    irerror('Wavenumber vector is empty!');
                end;
            end;
            
            
            y = data.X(obsidx(1, 1), :);
            x = data.fea_x;
            plot_curve_pieces(x, y, 'Color', [0, 0, 0], 'LineWidth', scaled(2));
            hold on;
            

            
                
            
            switch o.type
                case 'f'
                    plot(x(vidx(1, 1))*[1, 1], [0, y(vidx(1, 1))], 'r', 'LineWidth', scaled(2));
                    draw_peaks(x, y, vidx(1, 1), 1);
                    
                case 'm'
                    vidx2 = vidx(1):vidx(2);
                    plot(x(vidx(1, 1))*[1, 1], [0, max(y)], 'r--', 'LineWidth', scaled(2));
                    plot(x(vidx(1, end))*[1, 1], [0, max(y)], 'r--', 'LineWidth', scaled(2));
                    [vv, ii] = max(y(vidx2));
                    draw_peaks(x, y, vidx2(ii), 1);
                    
                case 'a'
                    vidx2 = vidx(1):vidx(2);
                    x_ = x(vidx2);
                    y_ = y(vidx2);
                    fill([x_, x_(end), x_(1)], [y_, 0, 0], [1, .5, .5], 'LineWidth', scaled(2), 'EdgeColor', [1, 0, 0]);
            end;
            
            format_xaxis(data);
            format_frank();
            make_box();
        end;
    end;
    
    methods(Access=protected)
        function data = do_use(o, data)
            
            vidx = v_x2ind(o.v, data.fea_x);
            
            switch o.type
                case 'f'
                    data.X = data.X(:, vidx);
                    data.fea_x = data.fea_x(vidx);
                case 'm'
                    data.X = max(data.X(:, vidx(1):vidx(2)), [], 2);
                    data.fea_x = 1;
                    data.fea_names = {'Maximum'};
                    data.xname = '';
                    data.xunit = '';
                case 'a'
                    data.X = sum(data.X(:, vidx(1):vidx(2)), 2);
                    data.fea_x = 1;
                    data.fea_names = {'Area'};
                    data.xname = '';
                    data.xunit = '';
            end;
        end;
    end;
end
