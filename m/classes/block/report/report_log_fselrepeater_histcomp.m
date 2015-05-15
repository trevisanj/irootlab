%> @brief Histograms and biomarkers comparison using various @ref subsetsprocessor objects
%>
%> Accessible from objtool, but not configurable at the moment (will use property defaults).
classdef report_log_fselrepeater_histcomp < report_soitem
    properties
        %> Cell of subsetsprocessor objects
        subsetsprocessors;
        %> =def_peakdetector()
        peakdetector;
        %> =def_biocomparer(). A @ref biocomparer object
        biocomparer;
        
        %> =1. Whether to plot the histograms
        flag_plot_hists = 1;

        %> Hint dataset
        ds_hint;
    end;
    
    methods
        function o = report_log_fselrepeater_histcomp()
            o.classtitle = 'Comparison between SSPs';
            o.inputclass = 'log_fselrepeater';
            o.flag_params = 0;
            o.flag_ui = 1;
        end;
    end;
    
    methods(Access=protected)
        function out = do_use(o, log)
            out = log_html();
            s = ['<h1>', o.classtitle, '</h1>']; 
            out.html = [s, o.get_html_graphics(log)];
            out.title = log.get_description();
        end;
    end;

    
    methods
        %> Generates a table with the best in each architecture, with its respective time and confidence interval
        %> @param log a solog_merger_fhg object
        function s = get_html_graphics(o, log)
            s = '';
            if isempty(o.subsetsprocessors)
                ssps = def_subsetsprocessors();
            else
                ssps = o.subsetsprocessors;
            end;
            hists = o.get_hists(log, ssps);
            n = numel(hists);

            if o.flag_plot_hists
                figure;
                log.draw_stackedhist_for_legend();
                show_legend_only();
                s = cat(2, s, o.save_n_close([], 0, []));

                %---> Histograms
                for i = 1:n
                    hist = hists(i);
                    figure;
                    hist.draw_stackedhists(o.ds_hint, {[], .8*[1 1 1]}, def_peakdetector(o.peakdetector));
                    xlabel('');
                    ylabel('');
                    make_axis_gray();
% % % %                     set(gca, 'color', 1.15*[0.8314    0.8157    0.7843]);
                    set(gca, 'Outerposition', [-0.1121    0.0502    1.2188    0.9498]);
                    legend off;
                    title(replace_underscores(hist.title));
                    maximize_window(gcf(), 4);
% % % %                     set(gcf, 'InvertHardCopy', 'off'); % This is apparently needed to preserve the gray background
% % % %                     set(gcf, 'color', [1, 1, 1]);
                    s = cat(2, s, o.save_n_close());
                end;
            end;
                
            %---> Biomarkers comparison table
            bc = def_biocomparer(o.biocomparer);
            s = cat(2, s, '<h2>Biomarkers comparison table of histograms above</h2>', 10); %bc.get_description(), '</h2>');
            [M, titles] = o.get_biocomparisontable(hists);
            s = cat(2, s, '<center>', html_table_std_colors(round(M*1000)/1000, [], titles, titles, '\', 0.5, 1, 4), '</center>', 10);
            
            
            % Reports the objects used
            s = cat(2, s, '<h2>Subsets processors used</h2>');
            a = ssps;
            for i = 1:numel(a)
                obj = a{i};
                s = cat(2, s, '<p><b>', obj.get_description, '</b></p>', 10, '<pre>', obj.get_report(), '</pre>', 10);
            end;
            s = cat(2, s, '<hr />', 10);

        end;
        
        
        function hists = get_hists(o, log, ssps)
            n = numel(ssps);
            % Histograms
            for i = 1:n
                ssp = ssps{i};
                hists(i) = ssp.use(log); %#ok<*AGROW>
                hists(i).title = ssp.title;
            end;
        end;
        
        
        %> Generates a matrix of item-wise Biomarkers Coherence Indexes
        %>
        %> @param hists array of log_hist
        %>
        %> @return [M, titles]
        function [M, titles] = get_biocomparisontable(o, hists)
            pd = def_peakdetector(o.peakdetector);
            bc = def_biocomparer(o.biocomparer);
            
            n = numel(hists);
            for i = 1:n
                hist = hists(i);
                pd = pd.boot(hist.fea_x, hist.grades);
                % Collects biomarkers
                pdidxs = pd.use([], hist.grades);
                wnss{i} = hist.fea_x(pdidxs);
                weightss{i} = hist.grades(pdidxs);
                titles{i} = hist.title;
            end;

            % + Mounts table
            M = eye(n);
            for i = 1:n
                for j = i+1:n
                    [matches, index] = bc.go(wnss{i}, wnss{j}, weightss{i}, weightss{j}); %#ok<ASGLU>
                    M(i, j) = index;
                    M(j, i) = index;
                end;
            end;
        end;
        
        
    end;
    
    methods(Static)
        function a = get_defaultsubsetsprocessors()
            a = def_subsetsprocessors();
        end
    end;
end