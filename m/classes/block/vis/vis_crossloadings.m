%> @brief Loadings vector of an @ref as_crossc
classdef vis_crossloadings < vis
    properties
        data_input;
        data_hint = [];
        idx_fea = 1;
        flag_trace_minalt = 0;
        flag_abs = 0;
        peakdetector = [];
        flag_envelope = 0;
        flag_bmtable = 0;
    end;
    
    methods
        function o = vis_crossloadings(o)
            o.classtitle = 'Loadings';
            o.inputclass = 'log_as_crossc';
        end;
    end;
    
    methods(Access=protected)
        function out = do_use(o, obj)
            out = [];
            nb = length(obj.blocks);
            l = 0;
            ymax = -Inf;
            ymin = Inf;
            
            % Makes a fader color
            color1 = rgb(find_color(1));
            color1 = color1*0.3+max(color1)*0.7;
            
            for i = 1:nb
                block = obj.blocks{i};
                temp = block.L(:, o.idx_fea);
                if o.flag_abs
                    temp = abs(temp);
                else
                    ymin = min([temp', ymin]);
                end;
                ymax = max([temp', ymax]);
                plot(block.L_fea_x, temp', 'Color', color1, 'LineWidth', scaled(1)); % yeah it is 1
                hold on;
                l = l+temp;
            end;
            l = l/nb;

            flag_p = ~isempty(o.peakdetector);
            if ~isempty(o.data_hint)
                hintx = o.data_hint.fea_x;
                hinty = mean(o.data_hint.X, 1);
            else
                hintx = [];
                hinty = [];
            end;
            
            draw_loadings(obj.blocks{1}.L_fea_x, l, hintx, hinty, [], o.flag_abs, ...
                          o.peakdetector, o.flag_trace_minalt, flag_p, flag_p);
            temp = struct();
            format_xaxis(obj.blocks{1});
            if o.flag_abs
                y0 = 0;
                y1 = ymax*1.05;
            else
                yspan = ymax-ymin;
                y0 = ymin-yspan*0.05;
                y1 = ymax+yspan*0.05;
            end;
            set(gca, 'YLim', [y0, y1]);
            set_title(o.classtitle, obj);
            make_box();
        end;
    end;
end
