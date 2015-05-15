%> @brief Single histogram report. Passes on to report_log_fselrepeater_hist
classdef report_soitem_fhg_hist < report_soitem
    properties
        %> Cell of subsetsprocessor objects
        subsetsprocessor = def_subsetsprocessor();
        %> =def_peakdetector()
        peakdetector = def_peakdetector();
        %> =[]. Hint dataset
        data_hint;
    end;
    
    methods
        function o = report_soitem_fhg_hist()
            o.classtitle = 'Histogram';
            o.inputclass = 'soitem_fhg';
            o.flag_params = 1;
            o.flag_ui = 1;
        end;
    end;
    
    methods(Access=protected)
        function out = do_use(o, item)
            
            r = report_log_fselrepeater_hist();
            r.subsetsprocessor = o.subsetsprocessor();
            r.peakdetector = o.peakdetector();
            r.data_hint = o.data_hint;
            
            out = r.use(item.log);
        end;
    end;
end
