%> @brief 
classdef report_soitem_merger_merger_fhg < report_soitem
    properties
        peakdetector;
        subsetsprocessor;
        %> @ref biocomparer object
        biocomparer;
        
        %> =report_log_fselrepeater_histcomp::get_defaultsubsetsprocessors().
        %> Cell of subsetsprocessors to perform biomarkers comparisons using different subsetsprocessors. If used, the comparison will be per stab
        %> Note that this property does not have a corresponding GUI input at the moment.
        subsetsprocessors;

        flag_draw_stability = 1;
        
        flag_biocomp_per_clssr = 1;
        flag_biocomp_per_stab = 1;
        flag_biocomp_all = 1;
        %> Biomarkers comparison per subsetsprocessor
        flag_biocomp_per_ssp = 1;
        %> Whether to show the nf4grades statistics
        flag_nf4grades = 1;
        %> =10. Stabilization number to be used in the "all" comparison
        stab4all = 10;

        %> Whether to generate a table where the varying element will be the nf4grades of a fixed-nf4grades subsetsprocessor
        flag_biocomp_nf4grades = 1;
    end;
    
    methods
        function o = report_soitem_merger_merger_fhg()
            o.classtitle = 'Biomarker comparison tables';
            o.inputclass = 'soitem_merger_merger_fhg';
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
        %> @param item a soitem_merger_merger_fhg object
        function s = get_html_graphics(o, item)
            s = '';
            
            if o.flag_biocomp_per_clssr
            
                % Finds out methodologies with more than one variation ("stabilizations")
                groupidxs = item.find_methodologygroups();
                n = numel(groupidxs);

                % Generates sub-reports for these groups separately
                for i = 1:n
                    if i > 1; s = cat(2, s, '<hr />', 10); end;
                    s = cat(2, s, sprintf('<h1>FHG setup: "%s"</h1>\n', item.items(1).s_methodologies{groupidxs{i}(1)}), o.get_html_biocomparison(item, groupidxs{i}));
                end;

                s = cat(2, s, '<h1>FHG setups table merge</h1>', item.html_biocomparisontable_stab(def_subsetsprocessor(o.subsetsprocessor), o.peakdetector, o.biocomparer));

                s = cat(2, s, '<hr />', 10);
            end;

            if o.flag_biocomp_per_stab
                stabs = unique(item.items(1).stabs);
                stabs(stabs < 0) = [];
                for i = 1:numel(stabs)
                    [s_temp, M(:, :, :, i), titles_temp] = o.get_html_biocomparison(item, item.find_stab(stabs(i))); %#ok<AGROW>
                    s = cat(2, s, sprintf('<h1>Stabilization: "stab%02d"</h1>\n', stabs(i)), s_temp);
                    
                    if i == 1
                        titles = titles_temp;
                    end;
                end;
                
                s = cat(2, s, o.get_html_stab_x_coherence(M, titles));
                s = cat(2, s, '<hr />', 10);
            end;
                
            if o.flag_biocomp_all
                idxs = item.find_stab(o.stab4all); % Picks one representant from each group
                idxs = idxs(:)'; % makes 10, 20, 10, 20, ...
                idxs = [idxs, item.find_single()];
                s = cat(2, s, '<h1>Comparison of Methodologies</h1>', 10, o.get_html_biocomparison(item, idxs));
                % Generates one report for comparison among ALL different methodologies
                s = cat(2, s, '<hr />', 10);
            end;
            
            if o.flag_biocomp_nf4grades
                s = cat(2, s, '<h1>Comparison of nf4grades</h1>', 10);
                stabs = unique(item.items(1).stabs);
                stabs(stabs < 0) = [];
                for i = 1:numel(stabs)
                    s = cat(2, s, sprintf('<h2>Comparison of nf4grades - stab%02d</h2>\n', stabs(i)));
                    s = cat(2, s, o.get_html_biocomp_nf4grades(item, item.items(1).find_stab(stabs(i))));
                end;
                
                s = cat(2, s, sprintf('<h2>Comparison of nf4grades - stab-all</h2>\n'));
                s = cat(2, s, o.get_html_biocomp_nf4grades(item, find(item.items(1).stabs >= 0))); %#ok<FNDSB>
                s = cat(2, s, '<hr />', 10);
            end;
            
            if o.flag_biocomp_per_ssp
                s = cat(2, s, '<h1>Comparison of subsetsprocessors</h1>', 10);

                stabs = unique(item.items(1).stabs);
                stabs(stabs < 0) = [];
                for i = 1:numel(stabs)
                    s = cat(2, s, sprintf('<h2>Comparison of subsetsprocessors - stab%02d</h2>\n', stabs(i)));
                    s = cat(2, s, o.get_html_biocomp_ssps(item, item.items(1).find_stab(stabs(i))));
                end;
                
                s = cat(2, s, sprintf('<h2>Comparison of subsetsprocessors - stab-all</h2>\n'));
                s = cat(2, s, o.get_html_biocomp_ssps(item, find(item.items(1).stabs >= 0))); %#ok<FNDSB>
                s = cat(2, s, '<hr />', 10);
            end;            


            
            % Average stability curves
            if o.flag_draw_stability
                idxs = find(item.items(1).stabs >= 0);
                n = numel(idxs);
                ni = numel(item.items);
                k = 0;
                for i = 1:n
                    for j = 1:ni
                        k = k+1;
                        log_rep = item.items(j).logs(idxs(i));
                        ds_stab(i) = log_rep.extract_dataset_stabilities(); %#ok<AGROW>
                        ds_stab(i).classlabels = {sprintf('stab%02d', item.items(j).stabs(idxs(i)))}; %#ok<AGROW>
                    end;
                end;
                ds = o.merge_ds_stab(ds_stab);
                ov = vis_hachures();
                figure;
                ov.use(ds);
                maximize_window([], 1.8);
                s = cat(2, s, o.save_n_close([], 0), '<hr />', 10);
            end;
            
            
            
            if o.flag_nf4grades
                %-----> nf for grades table
                s = cat(2, s, o.get_html_nf4grades(item, 1:numel(item.items(1).logs)));
                s = cat(2, s, '<hr />', 10);
            end;
            
            % Reports the objects used
            s = cat(2, s, '<h2>Setup of some objects used</h2>');
            a = {def_subsetsprocessor(o.subsetsprocessor), def_peakdetector(o.peakdetector), def_biocomparer(o.biocomparer)};
            for i = 1:numel(a)
                obj = a{i};
                s = cat(2, s, '<p><b>', obj.get_description, '</b></p>', 10, '<pre>', obj.get_report(), '</pre>', 10);
            end;
            
            if o.flag_biocomp_per_ssp
                a = o.get_ssps();
                for i = 1:numel(a)
                    obj = a{i};
                    s = cat(2, s, '<p><b>', obj.get_description, '</b></p>', 10, '<pre>', obj.get_report(), '</pre>', 10);
                end;
            end;
            s = cat(2, s, '<hr />', 10);
        end;
        
        
        function s = get_html_biocomp_nf4grades(o, item, idxs)
            s = '';
            [temp, M, titles] = item.html_biocomparisontable_nf4grades(idxs, def_subsetsprocessor(o.subsetsprocessor), o.peakdetector, o.biocomparer);
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

        
        function ssps = get_ssps(o)
            if isempty(o.subsetsprocessors)
                ssps = report_log_fselrepeater_histcomp.get_defaultsubsetsprocessors();
            else
                ssps = o.subsetsprocessors;
            end;
        end;
        
        function s = get_html_biocomp_ssps(o, item, idxs)
            s = '';
            [temp, M, titles] = item.html_biocomparisontable_ssps(idxs, o.get_ssps(), o.peakdetector, o.biocomparer); %#ok<NASGU,ASGLU>
            s = cat(2, s, temp);
        end;


        
        
        function [s, M, titles] = get_html_biocomparison(o, item, idxs)
            ssp = def_subsetsprocessor(o.subsetsprocessor);

            [s_temp, M, titles] = item.html_biocomparisontable(idxs, ssp, o.peakdetector, o.biocomparer);
            s = cat(2, s_temp);
        end;
        

        
        
        
        %> nf4grades table
        function s = get_html_nf4grades(o, item, idxs)
            ssp = subsetsprocessor(); %#ok<CPROP,PROP>
            ssp.nf4gradesmode = 'stability';
            s = '';
            s = cat(2, s, '<h2>Number of informative features</h2>', 10, item.html_nf4grades(idxs, ssp));
        end;
        

        % creates a log_celldata to represent better what is in the table
        function s = get_html_stab_x_coherence(o, M, titles)
            ds = o.get_dataset_stab_x_coherence(M, titles);
            a = vis_hachures();
            figure;
            a.use(ds);
            maximize_window([], 1.8);
            s = o.save_n_close([], 0);
        end;
                
              
        %> Returns a dataset containing (stabilization) x (coherence index) information
        function ds = get_dataset_stab_x_coherence(o, M, titles)
            ds = irdata;
            [nor, dummy, no_datasets, no_stabs] = size(M); %#ok<ASGLU>
            
            no = nor*(nor-1)/2*no_datasets;
            ds.X = zeros(no, no_stabs);
            ds.classes = zeros(no, 1);
            
            k = 1;
            l = 0;
            for i = 2:nor % These for's iterate through the upper triangle of M
                for j = 1:i-1
                    ds.X(k:k+no_datasets-1, :) = M(i, j, :, :);
                    ds.classes(k:k+no_datasets-1, :) = l;
                    ds.classlabels{l+1} = sprintf('%s vs. %s', titles{i}, titles{j});
                    k = k+no_datasets;
                    l = l+1;
                end;
            end;
            
            ds.title = [o.title, ' - stabilization curves'];
            ds.xname = 'Stabilization';
            ds.yname = 'Coherence';
            ds.xunit = '';
            ds.yunit = '';
            ds = ds.assert_fix();
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
