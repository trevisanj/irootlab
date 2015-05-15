%> @brief Histograms ane Biomarkers comparison tables - Several set-ups (including stabilizations). Comparisons using histograms, biomarker comparison tables/(heat maps).
classdef report_soitem_merger_fhg < report_soitem
    properties
        peakdetector;
        subsetsprocessor;
        %> @ref biocomparer object
        biocomparer;
        
        %> =report_log_fselrepeater_histcomp::get_defaultsubsetsprocessors().
        %> Cell of subsetsprocessors to perform biomarkers comparisons using different subsetsprocessors. If used, the comparison will be per stab
        %> Note that this property does not have a corresponding GUI input at the moment.
        subsetsprocessors;
        
        
        flag_draw_histograms = 1;
        flag_draw_stability = 1;
        
        flag_biocomp_per_clssr = 1;
        flag_biocomp_per_stab = 1;
        flag_biocomp_all = 1;
        %> Biomarkers comparison per subsetsprocessor
        flag_biocomp_per_ssp = 1;
        flag_nf4grades = 1;
        %> =10. Stabilization number to be used in the "all" comparison
        stab4all = 10;
        
        %> Whether to generate a table where the varying element will be the nf4grades of a fixed-nf4grades subsetsprocessor
        flag_biocomp_nf4grades = 1;
    end;
    
    methods
        function o = report_soitem_merger_fhg()
            o.classtitle = 'Several comparisons'; %Histograms and biomarkers comparison tables';
            o.inputclass = 'soitem_merger_fhg';
            o.flag_params = 1;
        end;
    end;
    
    methods(Access=protected)
        function out = do_use(o, item)
            out = log_html();
            if o. flag_biocomp_per_clssr || o.flag_biocomp_per_stab || o.flag_biocomp_all || o.flag_nf4grades
                item = item.calculate_stabilities(def_subsetsprocessor(o.subsetsprocessor));
            end;
            
            s = o.get_standardheader(item);
            
            out.html = [s, o.get_html_graphics(item)];
            out.title = item.get_description();
        end;
    end;

    
    methods
        %> Generates a table with the best in each architecture, with its respective time and confidence interval
        %> @param item a soitem_merger_fhg object
        function s = get_html_graphics(o, item)
            s = '';
            
            ssp = def_subsetsprocessor(o.subsetsprocessor);
            pd = def_peakdetector(o.peakdetector);
            bc = def_biocomparer(o.biocomparer);
            
            
            if o.flag_biocomp_per_clssr
                % Finds out setups with more than one variation ("stabilizations")
                groupidxs = item.find_methodologygroups();
                n = numel(groupidxs);

                if n <= 0
                    % Giving no message at the moment
                else
                    s = cat(2, s, '<h1>Stabilization comparison grouped by FHG-classifier setup</h1>', 10);
                    % Generates sub-reports for these groups separately
                    for i = 1:n
                        if i > 1; s = cat(2, s, '<hr />', 10); end;
                        s = cat(2, s, sprintf('<h2>FHG setup: "%s"</h2>\n', item.s_methodologies{groupidxs{i}(1)}), o.get_html_from_logs(item, groupidxs{i}));
                    end;

                    s = cat(2, s, '<h2>FHG setups table merge</h2>', item.html_biocomparisontable_stab(ssp, pd, bc));

                    s = cat(2, s, '<hr />', 10); % All sections divided by double HR
                    s = cat(2, s, '<hr />', 10);
                end;
            end;

            if o.flag_biocomp_per_stab
                s = cat(2, s, '<h1>FHG setup comparison grouped by stabilization</h1>', 10);
                stabs = unique(item.stabs);
                for i = 1:numel(stabs)
                    s = cat(2, s, sprintf('<h2>Stabilization: "%d"</h2>\n', stabs(i)), o.get_html_from_logs(item, item.find_stab(stabs(i))));
                end;
                s = cat(2, s, '<hr />', 10);
                s = cat(2, s, '<hr />', 10);
            end;
                
            if o.flag_biocomp_all
                % Picks one representant from each group
                idxs = [item.find_stab(o.get_stab4all(item))]; %; item.find_stab(20)];
                idxs = idxs(:)'; % makes 10, 20, 10, 20, ...
                idxs = [idxs, item.find_single()];
                s = cat(2, s, '<h1>Comparison of all setups</h1>', 10, ...
                    '<p>In this section, FHG-classifier setups will use stabilization=<b>', int2str(o.get_stab4all(item)), '</b></p>', 10, ...
                    o.get_html_from_logs(item, idxs));
                % Generates one report for comparison among ALL different methodologies
                s = cat(2, s, '<hr />', 10);
                s = cat(2, s, '<hr />', 10);
            end;

            
            if o.flag_biocomp_nf4grades
                ssp = def_subsetsprocessor(o.subsetsprocessor);
                s = cat(2, s, '<h1>Comparison of number of selected features grouped per stabilization</h1>', 10, ...
                    '<p>Number of selected features varying from 1 to <b>', int2str(item.logs(1).nfmax), '</b></p>', 10, ...
                    '<p>Only the FHG-classifier setups are compared in this section. Each stabilization case summarizes all FHG-classifier set-ups.</p>', 10, ...
                    '<p>Base subsets processor used in this section (from which nf4grades will vary):<br>' , 10, ...
                    '<pre>', ssp.get_report(), '</pre></p>', 10);
                
                
                stabs = unique(item.stabs);
                stabs(stabs < 0) = [];
                if isempty(stabs)
                    s = cat(2, s, '<p><font color=red>Comparison of number of selected features available for FHG-classifier set-ups (with stabilization) only.</font></p>');
                else
                    for i = 1:numel(stabs)
                        s = cat(2, s, sprintf('<h2>Stabilization: %02d</h2>\n', stabs(i)));
                        s = cat(2, s, o.get_html_biocomp_nf4grades(item, item.find_stab(stabs(i)), ssp));
                    end;

                    s = cat(2, s, sprintf('<h2>Stabilizations: all</h2>\n'));
                    s = cat(2, s, o.get_html_biocomp_nf4grades(item, find(item.stabs >= 0), ssp)); %#ok<FNDSB>
                end;
                s = cat(2, s, '<hr />', 10);
                s = cat(2, s, '<hr />', 10);
            end;
            
            if o.flag_biocomp_per_ssp
                ssps = o.get_ssps();
                s = cat(2, s, '<h1>Comparison of subsets processors</h1>', 10);

                stabs = unique(item.stabs);
                stabs(stabs < 0) = [];
                if isempty(stabs)
                    s = cat(2, s, '<p><font color=red>Comparison of subsets processors available for FHG-classifier setups (with stabilization) only</font></p>');
                else
                    for i = 1:numel(stabs)
                        s = cat(2, s, sprintf('<h2>Stabilization: %02d</h2>\n', stabs(i)));
                        s = cat(2, s, o.get_html_biocomp_ssps(item, item.find_stab(stabs(i)), ssps));
                    end;

                    s = cat(2, s, sprintf('<h2>Stabilization: all</h2>\n'));
                    s = cat(2, s, o.get_html_biocomp_ssps(item, find(item.stabs >= 0), ssps)); %#ok<FNDSB>
                end;
                
                
                % Reports the objects used
                s = cat(2, s, '<h2>Subsets processors used in this section</h2>');
                a = ssps;
                for i = 1:numel(a)
                    obj = a{i};
                    s = cat(2, s, '<p><b>', obj.get_description, '</b></p>', 10, '<pre>', obj.get_report(), '</pre>', 10);
                end;
                
                s = cat(2, s, '<hr />', 10);
                s = cat(2, s, '<hr />', 10);
            end;            
            

            % Average stability curves
            if o.flag_draw_stability
                idxs = find(item.stabs >= 0);
                n = numel(idxs);
                if n <= 0
                    s = cat(2, s, '<p><font color=red>Average stability curve per stabilization available for methodologies with stabilization only</font></p>');
                else
                    for i = 1:n
                        log_rep = item.logs(idxs(i));
                        ds_stab(i) = log_rep.extract_dataset_stabilities(); %#ok<AGROW>
                        ds_stab(i).classlabels = {sprintf('stab%02d', item.stabs(idxs(i)))}; %#ok<AGROW>
                    end;
                    ds = o.merge_ds_stab(ds_stab);
                    ov = vis_hachures();
                    figure;
                    ov.use(ds);
                    maximize_window([], 1.8);
                    s = cat(2, s, '<h1>Average stability curve per stabilization</h1>', 10);
                    s = cat(2, s, o.save_n_close([], 0));
                end;
                s = cat(2, s, '<hr />', 10);
                s = cat(2, s, '<hr />', 10);
            end;
            
            if o.flag_nf4grades
                %-----> nf for grades table
                s = cat(2, s, '<h1>Number of informative features table</h1>', 10, ...
                    '<p>These numbers will only vary if the base subsetsprocessor provided nas nf4gradesmode=''stability''.</p>', 10, ...
                    o.get_html_nf4grades(item, 1:numel(item.logs)));
                s = cat(2, s, '<hr />', 10);
                s = cat(2, s, '<hr />', 10);
            end;
            
            % Reports the objects used
            s = cat(2, s, '<h1>Properties of some objects used</h1>');
            a = {pd, bc};
            for i = 1:numel(a)
                obj = a{i};
                s = cat(2, s, '<p><b>', obj.get_description, '</b></p>', 10, '<pre>', obj.get_report(), '</pre>', 10);
            end;
            s = cat(2, s, '<hr />', 10);
            s = cat(2, s, '<hr />', 10);
        end;
        
        %
        function s = get_html_biocomp_nf4grades(o, item, idxs, ssp)
            s = '';
            [temp, M, titles] = item.html_biocomparisontable_nf4grades(idxs, ssp, o.peakdetector, o.biocomparer);
            s = cat(2, s, temp);

            % Draws as image as well, easier to perceive
            figure;
            means = mean(M, 3);
            imagesc(means);
            xtick = 1:size(M, 1);
            set(gca(), 'xtick', xtick, 'ytick', xtick, 'xticklabel', titles, 'yticklabel', titles);
            hcb = colorbar();
            format_frank([], [], hcb);
            s = cat(2, s, o.save_n_close([], 0));
        end;

        function s = get_html_biocomp_ssps(o, item, idxs, ssps)
            s = '';
            [temp, M, titles] = item.html_biocomparisontable_ssps(idxs, ssps, o.peakdetector, o.biocomparer); %#ok<NASGU,ASGLU>
            s = cat(2, s, temp);
            aa = arrayfun(@int2str, 1:numel(titles), 'UniformOutput', 0); % Makes ticks 1, 2, 3 ... because titles are too long
            
            % Draws as image as well, easier to perceive
            figure;
            means = mean(M, 3);
            imagesc(means);
            xtick = 1:size(M, 1);
            set(gca(), 'xtick', xtick, 'ytick', xtick, 'xticklabel', aa, 'yticklabel', aa);
            hcb = colorbar();
            format_frank([], [], hcb);
            s = cat(2, s, o.save_n_close([], 0));
        end;

        
        %
        function s = get_html_from_logs(o, item, idxs)
            s = '';
            ssp = def_subsetsprocessor(o.subsetsprocessor);

            % Legend
            if o.flag_draw_histograms            
                s = cat(2, s, '<h3>Histograms</h3>', 10);

                % Legend
                log_rep = item.logs(idxs(1));
                figure;
                log_rep.draw_stackedhist_for_legend();
                show_legend_only();
                s = cat(2, s, o.save_n_close([], 0, []));
                v = vis_stackedhists();
                v.data_hint = []; % Could have a o.data_hint;
                v.peakdetector = def_peakdetector(o.peakdetector);
            end;

            n = numel(idxs);
            for i = 1:n
                log_rep = item.logs(idxs(i));               
                if o.flag_draw_histograms
                    hist = ssp.use(log_rep);
                    figure;
                    v.use(hist);
                    make_axis_gray();
                    legend off;
                    % Will occupy 70% of screen width, and render the IMG tag without size specification
                    maximize_window(gcf(), 4, .7);
                    s = cat(2, s, '<h3>', item.get_logdescription(idxs(i)), '</h3>', o.save_n_close([], 0));
                end;

                if o.flag_draw_stability
                    % Stability curve
                    ds_stab(i) = log_rep.extract_dataset_stabilities(); %#ok<AGROW>
                    ds_stab(i).classlabels = {replace_underscores(sprintf('%s stab%02d', item.s_methodologies{idxs(i)}, item.stabs(idxs(i))))}; %#ok<AGROW>
                end;
            end;

            % Stability curves
%             ds = o.merge_ds_stab(ds_stab);
%             ov = vis_alldata();
            if o.flag_draw_stability
                for j = 1:2 % 1 pass for the legend, second for the graphics
                    figure;
                    for i = 1:n
                        plot(ds_stab(i).fea_x, ds_stab(i).X, 'Color', find_color(i), 'LineWidth', scaled(2)); % 'LineStyle', find_linestyle(i),
                        hold on;
                    end;
                    format_xaxis(ds_stab(1));
                    format_yaxis(ds_stab(1));
                    set(gca, 'xlim', get(gca, 'xlim'), 'ylim', get(gca, 'ylim')); % Just to switch to manual mode
                    make_box();
                    
                    if j == 1
                        legend(cat(2, ds_stab.classlabels));
                        format_frank();
                        show_legend_only();
                    else
                        format_frank();
                    end;
                    s = cat(2, s, o.save_n_close([], 0));
                end;
                        
            end;
            
            % Biomarkers coherence tables
            s = cat(2, s, '<h3>Biomarkers coherence</h3>', 10, item.html_biocomparisontable(idxs, ssp, o.peakdetector, o.biocomparer));
        end;

        
        %> nf4grades table
        function s = get_html_nf4grades(o, item, idxs)
            ssp = def_subsetsprocessor(o.subsetsprocessor);
            s = item.html_nf4grades(idxs, ssp);
        end;
    end;
    
    methods
        %
        function ssps = get_ssps(o)
            if isempty(o.subsetsprocessors)
                ssps = report_log_fselrepeater_histcomp.get_defaultsubsetsprocessors();
            else
                ssps = o.subsetsprocessors;
            end;
        end;

        %> Because o.stab4all may be out of the chart
        %> If o.stab4all was not practiced, will return maximum
        %> stabilization used.
        function n = get_stab4all(o, item)
            if any(item.stabs == o.stab4all)
                n = o.stab4all;
            else
                n = max(item.stabs);
            end;
        end;
    end;
    
    methods(Access=protected)
        %> Merges datasets but first makes sure they all have same number of features
        function ds = merge_ds_stab(o, daa) %#ok<MANU>
            nf = max([daa.nf]);
            for i = 1:numel(daa)
                if daa(i).nf < nf
                    temp = daa(i).X;
                    [ro, co] = size(temp);
                    daa(i).X = NaN(ro, nf);
                    daa(i).X(1:ro, 1:co) = temp;
                    daa(i).fea_x = 1:nf;
                    daa(i) = daa(i).assert_fix(); % just in case
                end;
            end;
            ds = data_merge_rows(daa);
        end;
    end;
end
