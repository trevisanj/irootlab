%> @brief Visualization - Loadings plots or Peak Location plots for loadings vectors
%>
%> @sa uip_vis_loadings.m
classdef vis_loadings < vis
    properties
        %> (optional) Hint dataset. Used to plot a black dashed thin spectrum line on the background
        data_hint = [];
        %> =1. (int vector) Index of columns from the Loadings matrix
        idx_fea = 1;
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
        function o = vis_loadings()
            o.classtitle = 'Loadings';
            o.inputclass = {'fcon_linear', 'block_cascade_base'};
        end;
    end;
    
    methods(Access=protected)
        function out = do_use(o, obj)
            out = [];
            
            legends = obj.get_L_fea_names(o.idx_fea);
            
            flag_p = ~isempty(o.peakdetector);
            if ~isempty(o.data_hint)
                hintx = o.data_hint.fea_x;
                hinty = mean(o.data_hint.X, 1);
            else
                hintx = [];
                hinty = [];
            end;

            if any(o.idx_fea > size(obj.L, 2))
                irerror(sprintf('There are only %d loadings!', size(obj.L, 2)));
            end;
            
            if ~o.flag_bmtable
                draw_loadings(obj.L_fea_x, obj.L(:, o.idx_fea), hintx, hinty, legends, o.flag_abs, ...
                              o.peakdetector, o.flag_trace_minalt, flag_p, flag_p, 0, o.flag_envelope);
            else
                draw_loadings_pl(obj.L_fea_x, obj.L(:, o.idx_fea), hintx, hinty, legends, o.flag_abs, ...
                              o.peakdetector);
            end;
            format_xaxis(obj);
            set_title(o.classtitle, obj);
            make_box();
        end;
    end;
end
