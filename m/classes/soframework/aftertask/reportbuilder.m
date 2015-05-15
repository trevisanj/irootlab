%> Report builder
classdef reportbuilder
    properties
        %> If activated, won't call the "use()" methods of the reports
        flag_simulation = 0;
    end;
    
    properties(SetAccess=protected)
        %> (Read-only) Directory found to put reports in
        dirname;
        %> (Read-only) Name of filename to store state
        DATAFILENAME = 'reportbuilder_state.data'
        %> whether finished
        flag_finished = 0;
    
        %> Classes-reports correspondence
        map = {...
               'soitem_diachoice', {{'get_report_soitem_sovalues', 'Flat comparison table (grouped by classifier and feature extraction)'}}; ... % soitem_diachoice descends from soitem_sovalues, but the former is output of latter (and fewer) tasks
               'soitem_items', {{'get_report_soitem_items', 'Curves/Images from Model Selection'}}; ...
               'soitem_foldmerger_fitest', {{'get_report_soitem_foldmerger_fitest', 'Confusion matrices for each system set-up'}}; ...
               'soitem_fhgs', {{'get_report_soitem_fhg_hist', 'Feature histogram'}, {'get_report_soitem_fhg_histcomp', 'Histograms comparison'}}; ...
               'soitem_merger_fhg', {{'get_report_soitem_merger_fhg', 'Histograms and biomarkers comparison tables'}}; ...
               'soitem_merger_merger_fhg', {{'get_report_soitem_merger_merger_fhg', 'Cross-dataset biomarker comparison tables'}}; ...
               'soitem_merger_merger_fitest', {{'get_report_soitem_merger_merger_fitest', 'General 2D performance comparison table'}, ...
                                               {'get_report_soitem_merger_merger_fitest_1d', 'General flat performance comparion table'}}; ...
              };
        %> Indicates which reports are switched on. I deactitaved 2 reports that generated figures
        flags_map2 = boolean([1, 0, 0, 1, 1, 1, 1, 1, 1]);
    end;
    
    methods
        function o = set_flag_map2(o, i, x)
            if isempty(o.flags_map2)
                [dummy, o.flags_map2] = o.get_map2(); %#ok<ASGLU>
            end;
            o.flags_map2(i) = x;
        end;
        
        %> Flattens .map
        function [z, flags, titles] = get_map2(o)
            m = size(o.map, 1);
            z = {};
            k = 0;
            for i = 1:m
                n = length(o.map{i, 2});
                for j = 1:n
                    k = k+1;
                    z(k, :) = {o.map{i, 1}, o.map{i, 2}{j}{1}};
                    titles{k} = o.map{i, 2}{j}{2};
                end;
            end;
            
            if isempty(o.flags_map2)
                flags = boolean(ones(1, k));
            else
                flags = boolean(o.flags_map2);
            end;
        end;
        
        %> Flat map with only the activated reports
        function z = get_map3(o)
            [a, flags, titles] = o.get_map2(); %#ok<NASGU>
            z = a(flags, :);
        end;
    end;        
    
    methods
        function o = reportbuilder()
        end;
        
        function o = go(o)
            setup_load();
            state = o.load_state(); % Will create "state" variable in local workspace
            o.assert_dir_exists(state.dirname);
            
            ipro = progress2_open('Report builder', [], 0, state.no_reports);
            while ~state.flag_finished
                state = o.cycle_(state);
                ipro = progress2_change(ipro, [], [], state.cnt);
            end;
            progress2_close(ipro);
            o.create_indexes();
            irverbose('Report builder finished!');
            o.print_link();
            o.flag_finished = 1;
        end;        
        
        %> Resets progress, will cause report execution to restart next
        %> time
        function o = reset(o)
            state = o.load_state(); % Will create "state" variable in local workspace
            state.i_file = 0;
            state.i_report = 0;
            state.no_files = numel(state.filemap);
            state.flag_finished = 0;
            state.cnt = 0;
            o.save_state(state);
        end;

        function o = print_link(o)
            state = o.load_state();
            pf = fullfile(pwd(), state.dirname, 'index.html');
            fprintf('View: <a href="matlab:web(''%s'', ''-new'')">%s</a>\n', pf, pf);
        end;

        
        %> Resets report building progress by re-creating state file
        function o = rebuild(o)
            o.create_state();
            o.flag_finished = 0;
        end;
      
        function print_status(o)
            fprintf('\n__Reports completion______________\n');
            if ~exist(o.DATAFILENAME, 'file')
                disp('Reports list not built yet');
                return;
            end;
            
            state = o.load_state();
            fprintf('Reports directory: %s\n', state.dirname);
            fprintf('Completed: %d/%d\n', state.cnt, state.no_reports);
            % Doesn't print because doesn't open if clicked when waiting for keyboard input
%             if exist(fullfile(pwd(), state.dirname, 'index.html'), 'file')
%                 o.print_link();
%             end;
            disp('==================================');
        end;
        
        %> Increments pointers, generates 1 report, saves state
        function state = cycle_(o, state)
            S_BACK = ['<p><input type="button" value="Back" onclick="window.history.back();" />&nbsp;&nbsp;<a href="index.html">Back</a></p>', 10];
            
            state.i_report = state.i_report+1;
            if state.i_file == 0 || state.i_report > state.filemap(state.i_file).no_reports
                state.i_file = state.i_file+1;
                state.i_report = 1;
            end;
            if state.i_file > state.no_files
                state.flag_finished = 1;
                return;
            end;

            % Makes report.
            % Exceptions are recorded into the output HTML and suppressed
            mi = state.filemap(state.i_file);
            li = mi.list(state.i_report);
            p = pwd();
            cd(state.dirname); % Must be there to use() report object (it generates figures etc)
            try
                o_report = o.(li.s_getter);
                o_report.title = ['File "', mi.infilename, '"'];
                load(fullfile('..', mi.infilename));
                item = r.item;
                if ~o.flag_simulation
                    o_html = o_report.use(item);
                else
                    o_html = log_html;
                    o_html.html = 'Simulation mode';
                end;
            catch ME
                o_html = log_html;
                o_html.html = strrep(ME.getReport(), char(10), '<br />');
                irverbose(ME.getReport(), 3);
            end;
            o_html.html = cat(2, S_BACK, o_html.html, S_BACK);
            o.save(li.outfilename, o_html);
            state.filemap(state.i_file).list(state.i_report).flag_saved = 1;
            cd(p);
            state.cnt = state.cnt+1;
            
            % Save state
            o.save_state(state);
        end;
       
        
        %> Loads state file. Creates if does not exist
        function state = load_state(o) %#ok<STOUT>
            if ~exist(o.DATAFILENAME, 'file')
                o.create_state();
            end;
            load(o.DATAFILENAME, '-mat'); % Variable "state" should be inside
        end;

        %> Saves existing state variable in file
        function o = save_state(o, state) %#ok<INUSD>
            save(o.DATAFILENAME, 'state');
            irverbose(sprintf('Saved Report Builder State to file ``%s``', o.DATAFILENAME), 1);
        end;

        %> Creates state file
        %>
        %> <verbatim>
        %> .dirname - name of subdirectory within pwd
        %> .scenename - name of scene extracted from scenesetup.m (optional)
        %> .filemap - file map generated by build_filemap()
        %> .i_file - index of last processed item of .filemap
        %> .i_report - index of last processed item of filemap(i_file).list
        %> .no_reports total number of reports
        %> .no_files - short to numel(.filemap)
        %> .flag_finished - set to 1 when all reports have been successfully generated
        %> .cnt - iteration counter (1 to no_reports)
        %> </endverbatim>
        function o = create_state(o)
            state.dirname = find_dirname('reports_');
            if exist('scenesetup.m', 'file')
                scenesetup;
                state.scenename = a.scenename;
            else
                state.scenename = '';
            end;
            [state.filemap, state.no_reports] = o.build_filemap();
            state.i_file = 0;
            state.i_report = 0;
            state.no_files = numel(state.filemap);
            state.flag_finished = 0;
            state.cnt = 0;
            o.save_state(state);
        end;

        %> Creates task structure array
        %>
        %> .infilename - mat filename starting with "output"
        %> .status     - 0: ok; -1: failed somehow
        %> .statusmsg  - message string, further details on -1 status
        %> .time_go       - time taken (extracted from file)
        %> .descr      - description (extracted from file)
        %> .dstitle    - dataset title (extracted from file)
        %> .no_reports - number of associated reports
        %> .list - structure array with following fields:
        %>     .s_getter - string with name of report getter method
        %>     .outfilename - output html file
        %>     .title - alleged report title
        %>
        %> @return [filemap structure, total number of reports]
        function [tt, no_total] = build_filemap(o)
            tt = struct.empty;
            no_total = 0;
            a = o.get_map3();
            classes = a(:, 1);
            getters = a(:, 2);
            
            dd = dir('soout_*.mat');
%             [dummy, idxs] = sort([dd.datenum]);
%             dd = dd(idxs); % Sorts by date
            if ~isempty(dd)
                names = {dd.name};
                no_files = numel(names);
                ipro = progress2_open('Report task builder', [], 0, no_files);
                it = 1; % 
                for i = 1:no_files
                    % Variables starting with "t_" will mount the file record
                    fn = names{i};
                    flag_has = 1; % If set to 0 inside, file will be skipped at the end of the "try" block
                    try
                        clear r;
                        load(fn);
                        
                        if ~exist('r', 'var')
                            tt(it).status = -1;
                            tt(it).statusmsg = 'No "r" variable inside .mat file';
                        else
                            item = r.item;
                            if strcmp(item.dstitle, '(not used)')
                                flag_has = 0; % Skips file if the dataset hasn't been used
                            else
                                b = cellfun(@(x) (isa(item, x)), classes); % Finds classes that match class of item
                                gttr = getters(b);
                                no_reports = numel(gttr);
                                for j = 1:no_reports
                                    o_report = o.(gttr{j}); % Instantializes report just to get class name
                                    tt(it).list(j).s_getter = gttr{j};
                                    tt(it).list(j).outfilename = [fn, '__', class(o_report), '.html'];
                                    tt(it).list(j).flag_saved = 0;
                                    tt(it).list(j).title = o_report.classtitle;
                                end;
                                if no_reports > 0
                                    tt(it).status = 0; %#ok<*AGROW>
                                    tt(it).time_go = r.time_go;
                                    tt(it).descr = item.get_description();
                                    tt(it).dstitle = item.dstitle();
                                    tt(it).no_reports = no_reports;
                                    tt(it).taskidx = r.taskidx;
                                    no_total = no_total+no_reports;
                                else
                                    flag_has = 0;
                                end;
                            end;
                        end;                        
                    catch ME
                        tt(it).status = -1;
                        tt(it).statusmsg = strrep(ME.getReport(), char(10), '<br />');
                        irverbose(sprintf('Failed processing file "%s": %s', fn, ME.message));
                    end;
                    if flag_has
                        temp = taskadder.parse_filename(fn);
                        ff = fields(temp);
                        for j = 1:numel(ff)
                            tt(it).(ff{j}) = temp.(ff{j});
                        end;
                        tt(it).infilename = fn;
                        it = it+1;
                    end;
                    ipro = progress2_change(ipro, [], [], i);
                end;
                progress2_close(ipro);
            end;
        end;
        
        %> Creates directory if it does not exist
        function o = assert_dir_exists(o, dirname)
            ff = fullfile('.', dirname);
            if ~exist(ff, 'dir')
                mkdir(ff);
                irverbose(sprintf('Created directory ``%s``', ff), 1);
            end;
        end;
    end;
    
    
    methods
        function o = create_indexes(o)
            state = o.load_state(); % Will create "state" variable in local workspace
            o.assert_dir_exists(state.dirname);
            [clsr, hist] = o.split_filemap(state.filemap);
            
            o.create_indexes_(state, clsr);
            o.create_indexes_(state, hist);
        end;
        
        function o = create_indexes_(o, state, filemap)
            flag_any_fhg = any([state.filemap.flag_fhg]); % To save from linking to FHG tables if there is no FHG task
            nMap = numel(filemap);
            if nMap == 0
                return;
            end;
            flag_fhg = filemap(1).flag_fhg;
            if ~flag_fhg 
                colnames = {'taskidx', 'taskname', 'ovr', 'cv', 'fename', 'clname', 'pairwise', 'grag'};
            else
                colnames = {'taskidx', 'taskname', 'ovr', 'cv', 'stab', 'casename'};
            end;
            ncSort = numel(colnames);
            
            % Makes reports strings and adds into filemap as a new "column"
            colnames{end+1} = 'reports';
            for k = 1:numel(filemap)
                fmk = filemap(k);
                s = '';
                for j = 1:numel(fmk.list)
                    li = fmk.list(j);
                    if li.flag_saved
                        s = cat(2, s, sprintf('<a href="%s">%s</a><br />\n', ...
                             li.outfilename, li.title));
                    else
                        s = cat(2, s, sprintf('<font color=#444444><em>%s</em></font><br />\n', ...
                             li.title));
                    end;
                end;
                filemap(k).reports = s;
            end;
            
            % Adds a "load data" column
            colnames{end+1} = 'loadlog';
            for k = 1:numel(filemap)
                filemap(k).loadlog = sprintf('<a href="matlab:load_soitem(''%s'')">L</a><br />\n', ...
                    filemap(k).infilename);
            end;
            
            nc = numel(colnames);

            cc = {};
            for i = 1:ncSort
                % HTML from start

                s_ = iif(~isempty(state.scenename), ...
                         ['Reports for Scene "', state.scenename, '"'], ...
                         'Reports index');
                s = ['<body bgcolor=#c6e8e0><h1>', s_, '</h1>', 10];
                
                if flag_fhg || flag_any_fhg
                    s = cat(2, s, ['<p><a href="', o.colname2filename('taskidx', ~flag_fhg), '">',...
                         iif(flag_fhg, 'Classification', 'Biomarkers identification'), ...
                         ' reports</a></p>']);
                end;

                fni = o.colname2filename(colnames{i}, flag_fhg);
                % Headers
                for j = 1:nc
                    if j > ncSort
                        a1 = ''; a2 = '';
                    elseif i == j
                        a1 = ''; a2 = '&#x25B2;';
                    else
                        fn = o.colname2filename(colnames{j}, flag_fhg);
                        a1 = sprintf('<a href="%s">', fn);
                        a2 = '</a>';
                    end;
                    cc{1}{j} = [a1, colnames{j}, a2];
                end;

                filemap_ = o.sort_by_column(filemap, colnames{i});
                
                % Table body
                for k = 1:nMap
                    fmk = filemap_(k);
                    if fmk.status == 0
                        for j = 1:nc
                            cc{k+1}{j} = fmk.(colnames{j});
                        end;
                    else
                        cc{k+1}{1} = [fmk.infilename, ' - ', fmk.statusmsg]; % Gotta test this making some report give error on purpose
                    end;
                end;

                s = cat(2, s, o.cell2table(cc), 10, '</body>');
                
                o_html = log_html();
                o_html.title = sprintf('Reports index - sorted by "%s"', colnames{i});
                o_html.html = s;
                o.save(fullfile(state.dirname, fni), o_html);
            end;
        end;
       
        
        function o = save(o, filename, log_html)
%             fn = fullfile(o.dirname, filename);
            fn = filename;
            h = fopen(fn, 'w');
            if h <= 0
                irerror(sprintf('Could''t create file "%s"', fn));
            end;
            fwrite(h, log_html.get_embodied());
            irverbose(sprintf('Created file "%s"', fn), 1);
            fclose(h);
        end;
    end;
   
    
    
    

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%% STATIC METHODS
    
    methods(Static)
        function s = colname2filename(colname, flag_fhg)
            if strcmp(colname, 'taskidx') && ~flag_fhg
                % "Absolute" index is file from classificfation framwework sorted by taskidx
                s = 'index.html';
            else
                s = sprintf('%s_sortby_%s.html', iif(flag_fhg, 'hist', 'clsr'), colname);
            end;
        end;
        
        %> Splits filemap into the non-FHG (classification framework) and FHG (biomarkers identification framework)
        function [clsr, hist] = split_filemap(filemap)
            flags = [filemap.flag_fhg];
            clsr = filemap(~flags);
            hist = filemap(flags);
        end;

        
        %> Generates HTML table
        function s = cell2table(cc)
            nRows = numel(cc);
            nCols = numel(cc{1});

            s = '';
            s = cat(2, s, '<center>', 10, '<table class=bo style="background-color: #ffffff">', 10);
            temp = cellfun(@(x) ['<td class=bob><div class=hel>', x, '</div></td>', 10], cc{1}, 'UniformOutput', 0);
            s = cat(2, s, '<tr>', 10, temp{:}, '</tr>', 10);
            for i = 2:nRows % skips header
                c = cc{i};
                if numel(c) == 1
                    % Error
                    s = cat(2, s, sprintf('<tr><td colspan=%d class=bob1>%s</td></tr>\n', nCols, c{1}));
                else
                    temp = cellfun(@(x) ['<td class=bob1>', iif(ischar(x), x, num2str(x)), '</td>', 10], c, 'UniformOutput', 0);
                    s = cat(2, s, '<tr>', 10, temp{:}, '</tr>', 10);
                end;
            end;
            s = cat(2, s, '</table>', 10, '</center>', 10);
        end;

        function filemap_ = sort_by_column(filemap, colname)
            if ischar(filemap(1).(colname))
                a = cellfun(@(x) sprintf('%100s', x), {filemap.(colname)}, 'UniformOutput', 0);
            else
                a = arrayfun(@(x) sprintf('%5d', x), [filemap.(colname)], 'UniformOutput', 0);
            end;
            % OVR always included in sort key
            for i = 1:numel(a)
                a{i} = [a{i}, sprintf('%5s', filemap(i).ovr)];
            end;
            % Taskidx always included in sort key
            for i = 1:numel(a)
                a{i} = [a{i}, sprintf('%5d', filemap(i).taskidx)];
            end;
            [dummy, idxs] = sort(a); %#ok<ASGLU>
            filemap_ = filemap(idxs);
        end;
    end;

    
    
    
    
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%% Report object getters
    %
    % These routines allow full control over the report object parameters
    % Parameters for these routines can be got from objtool if the GUI interface for the report is properly set.
    %
    methods
        function r = get_report_soitem_merger_fhg(o) %#ok<*MANU>
            r = report_soitem_merger_fhg();
            r.flag_images = 1;
            r.flag_tables = 1;
            r.peakdetector = [];
            r.subsetsprocessor = [];
            r.biocomparer = [];
            r.subsetsprocessors = [];
            r.flag_draw_histograms = 1;
            r.flag_draw_stability = 1;
            r.flag_biocomp_per_clssr = 1;
            r.flag_biocomp_per_stab = 1;
            r.flag_biocomp_all = 1;
            r.flag_biocomp_per_ssp = 1;
            r.flag_nf4grades = 1;
            r.stab4all = 10;
            r.flag_biocomp_nf4grades = 1;
        end;
        
%        function r = get_report_soitem_fhg(o)
%            r = report_soitem_fhg();
%            r.flag_images = 1;
%            r.flag_tables = 1;
%           r.peakdetector = [];
%            r.subsetsprocessor = [];
%        end;

        function r = get_report_soitem_fhg_hist(o)
            r = report_soitem_fhg_hist();
            r.data_hint = load_data_hint();
            r.peakdetector = [];
            r.subsetsprocessor = [];
        end;

        
        function r = get_report_soitem_fhg_histcomp(o)
            r = report_soitem_fhg_histcomp();
            r.flag_images = 1;
            r.flag_tables = 1;
            r.peakdetector = [];
            r.subsetsprocessors = [];
            r.biocomparer = [];
        end;

        function r = get_report_soitem_merger_merger_fhg(o)
            r = report_soitem_merger_merger_fhg();
            r.flag_images = 1;
            r.flag_tables = 1;
            r.peakdetector = [];
            r.subsetsprocessors = [];
            r.biocomparer = [];
            r.subsetsprocessor = [];
            r.flag_draw_stability = 1;
            r.flag_biocomp_per_clssr = 1;
            r.flag_biocomp_per_stab = 1;
            r.flag_biocomp_all = 1;
            r.flag_biocomp_per_ssp = 1;
            r.flag_nf4grades = 1;
            r.stab4all = 10;
            r.flag_biocomp_nf4grades = 1;
        end;

        function r = get_report_soitem_sovalues(o)
            r = report_soitem_sovalues();
            r.flag_images = 1;
            r.flag_tables = 1;
            r.flag_ptable = 1;
        end;
                
        function r = get_report_soitem_foldmerger_fitest(o)
            r = report_soitem_foldmerger_fitest();
            r.flag_images = 1;
            r.flag_tables = 1;
        end;
        
       function r = get_report_soitem_items(o)
            r = report_soitem_items();
       end;

       function r = get_report_soitem_merger_merger_fitest(o)
            r = report_soitem_merger_merger_fitest();
            r.minimum = [];
            r.maximum = [];
       end;

       function r = get_report_soitem_merger_merger_fitest_1d(o)
            r = report_soitem_merger_merger_fitest_1d();
       end;
    end;
end
