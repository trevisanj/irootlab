%> @brief Visualization - Stacked histograms
%>
%> Accessible from objtool, but not configurable (will use properties defaults).
classdef vis_stackedhists < vis
    properties
        data_hint = [];
        peakdetector = def_peakdetector();
        colors = {[], .85*[1, 1, 1]};
    end;
    
    methods
        function o = vis_stackedhists(o)
            o.classtitle = 'Stacked Histograms';
            o.inputclass = {'log_hist'};
            o.flag_params = 1;
        end;
    end;
    
    methods(Access=protected)
        function out = do_use(o, obj)
            out = [];
            obj.draw_stackedhists(o.data_hint, o.colors, o.peakdetector);
            set_title(o.classtitle, obj);
        end;
    end;
end
