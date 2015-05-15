%> @brief Single histogram report
classdef report_log_fselrepeater_hist < irreport
    properties
        %> Cell of subsetsprocessor objects
        subsetsprocessor = def_subsetsprocessor();
        %> =def_peakdetector()
        peakdetector = def_peakdetector();
        %> =[]. Hint dataset
        data_hint;
        %> ='kun' (Kuncheva) (@sa feacons_kun.m) Feature stability type
        stabilitytype = 'kun';
    end;
    
    methods
        function o = report_log_fselrepeater_hist()
            o.classtitle = 'Histogram report';
            o.inputclass = 'log_fselrepeater';
            o.flag_params = 1;
            o.flag_ui = 1;
        end;
    end;
    
    methods(Access=protected)
        function out = do_use(o, log)
            out = log_html();
            
            s = '<h1>Histogram</h1>';
            
            out.html = [s, o.get_html_graphics(log)];
            out.title = log.get_description();
        end;
    end;

    
    methods
        %> Generates a table with the best in each architecture, with its respective time and confidence interval
        %> @param log a solog_merger_fhg object
        function s = get_html_graphics(o, log)
            s = '';

            ssp = def_subsetsprocessor(o.subsetsprocessor);
            hist = ssp.use(log);
        
            v = vis_stackedhists();
            v.data_hint = o.data_hint;
            v.peakdetector = def_peakdetector(o.peakdetector);
            

            figure;
            v.use(hist);
            show_legend_only();
            s = cat(2, s, o.save_n_close([], 0, []));
            
            figure;
            v.use(hist);
            make_axis_gray();
            legend off;
            maximize_window(gcf(), 4);
            s = cat(2, s, o.save_n_close());
            
            % Stability curve
            ds_stab = log.extract_dataset_stabilities(o.stabilitytype, 'uni');
            ov = vis_means();
            figure;
            ov.use(ds_stab);
            legend off;
            title('');
%             maximize_window(gcf(), 2);
            s = cat(2, s, o.save_n_close([], 0));
        end;       
    end;
end