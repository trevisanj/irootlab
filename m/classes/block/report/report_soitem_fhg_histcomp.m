%> @brief Passes on to report_log_fselrepeater_histcomp
%>
%> @sa report_log_fselrepeater_histcomp
classdef report_soitem_fhg_histcomp < report_soitem
    properties
        peakdetector;
        biocomparer;
        subsetsprocessors;
        %> =1. Whether to plot the histograms
        flag_plot_hists = 1;
    end;
    
    methods
        function o = report_soitem_fhg_histcomp()
            o.classtitle = 'Histograms comparison';
            o.inputclass = 'soitem_fhg';
            o.flag_params = 0;
        end;
    end;
    
    methods(Access=protected)
        function out = do_use(o, obj)
            
            r = report_log_fselrepeater_histcomp();
            r.peakdetector = o.peakdetector;
            r.biocomparer = o.biocomparer;
            r.subsetsprocessors = o.subsetsprocessors;
            r.flag_plot_hists = o.flag_plot_hists;

            out = r.use(obj.log);
        end;
    end;
end
