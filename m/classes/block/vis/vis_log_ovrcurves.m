%> @brief Visualization of Grades Curves stored inside a log_ovrcurves object
classdef vis_log_ovrcurves < vis
    properties
        %> (optional) Hint dataset. Used to plot a black dashed thin spectrum line on the background
        data_hint = [];
        %> =0. Whether to trace a dashed horizontal line to show a minimum altiture threshold from the @c peakdetector
        %>
        %> This property is only used if the @pc peakdetector has been specified
        flag_trace_minalt = 0;
        %> =0. Whether to take the abs() of the  of the loadings
        flag_abs = 0;
        %> =[]. Peak detector to mark peaks in the Loadings and Peak Location plots
        peakdetector = [];
        %> =0. Loadings Envelope mode. When loadings are very spiky, this can be set to =1 to merge adjacent peaks with a thicker line.
        %>
        %> This only takes effect if @c flag_bmtable is 0
        flag_envelope = 0;
        %> =0. Activates the "Peak Location Plot" mode
        flag_bmtable = 0;
    end;
    
    methods
        function o = vis_log_ovrcurves(o) %#ok<INUSD>
            o.classtitle = 'Feature grades (multiple curves)';
            o.inputclass = 'log_ovrcurves';
            o.flag_params = 1;
        end;
    end;
    
    methods(Access=protected)
        function out = do_use(o, log)
            out = [];
            
            flag_p = ~isempty(o.peakdetector);
            if ~isempty(o.data_hint)
                hintx = o.data_hint.fea_x;
                hinty = mean(o.data_hint.X, 1);
            else
                hintx = [];
                hinty = [];
            end;
            
            % Eliminates the color index corresponding to the reference class
            % This will synchonize colors with other plots that plot data from the
            % reference class.
            colorindexes = 1:size(log.gradess, 1)+1;
            colorindexes(log.idx_ref) = [];

            
            if ~o.flag_bmtable
                draw_loadings(log.fea_x, log.gradess', hintx, hinty, log.legends, o.flag_abs, ...
                              o.peakdetector, o.flag_trace_minalt, flag_p, flag_p, 0, o.flag_envelope, colorindexes);
                format_yaxis(log);
            else
                draw_loadings_pl(log.fea_x, log.gradess', hintx, hinty, log.legends, o.flag_abs, ...
                              o.peakdetector, colorindexes);
            end;
            set_title(o.classtitle, log);
            format_xaxis(log);
            make_box();
        end;
    end;
end