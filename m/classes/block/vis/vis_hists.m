%> @brief Visualization - Histograms from @ref log_hist
%>
%> This visualization plots the histograms for each moment of a Forward Feature Selection: first feature selected; second feature
%> selected ...
%>
%> @sa uip_vis_hists.m
classdef vis_hists < vis
    properties
        data_hint = [];
        idx_hist = 1;
        flag_group = 0;
    end;
    
    methods
        function o = vis_hists(o)
            o.classtitle = 'Feature-rank-wise Histograms';
            o.inputclass = {'log_hist'};
        end;
    end;
    
    methods(Access=protected)
        function out = do_use(o, obj)
            out = [];
            obj.draw_hists(o.idx_hist, o.data_hint, o.flag_group);
        end;
    end;
end
