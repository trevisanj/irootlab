% %> @ingroup soframework
%> @brief Creates graph of tasks
%>
%> @todo The task graph should be meta-defined instead of hard-coded in a sequence of loops. This would allow for flexibility in the task order
classdef taskadder
    properties
        %> taskmanager object
        tm;

        %> List of "wrapper" classifiers (ones without embedded feature selection)
        %> Classnames:
        %>   @arg goer_clarchsel__<clwrapper{i}>
        %>
        %> @note the list in @fhg_fswrapper_cl will be united with this one, as FHG requires the CLARCHSEL step
        %> 
        %> @sa @ref fe and @ref fhgstab properties
        clwrapper = {'ldc', 'qdc', 'knn'};
        
        %> List of classifiers with embedded feature selection.
        %> Classnames:
        %>   @arg goer_clarchsel__<clembedded{i}>
        %>   @arg goer_fhg__<clembedded{i}>__stab00
        %>   @arg goer_undersel for each clembedded{i}
        clembedded = {'lasso'};
        
        %> List of feature extraction methods.
        %> Classnames:
        %>   @arg goer_fe__<fe{i}>__<clwrapper{j}>
        %>   @arg goer_undersel for each (fe{i}, clwrapper{j})
        fe = {'pca', 'pls', 'ffs', 'manova', 'fisher', 'spline', 'lasso'};
        
        %> Stabilizations that will be put in practice
        %>
        %> @sa fhg_fswrapper_cl
        fhg_stab = [0, 2, 5, 10, 20];
        
        %> List of fhg_fswrapper to use with fhg_fswrapper_cl
        fhg_fswrapper_fs = {'ffs'};
        %> List of classifiers to use with fhg_fswrapper_fs
        %> Classnames:
        %>   @arg goer_fhg__<fhg_fswrapper_fs{i}>_<fhg_fswrapper_cl{j}>__stab<fhg_stab(k)>
        fhg_fswrapper_cl = {'ldc', 'qdc', 'knn'};
        %> List of other FHG's to run (apart from fhg_fswrapper)
        %> Classnames:
        %>   @arg goer_fhg__<fhg_others{i}>__stab00
        fhg_others = {'lasso', 'manova', 'fisher'};
    end;
    
    properties(SetAccess=protected)
        flag_booted = 0;
        %> Cross-validation's "k"
        k;
        %> Number of classes of base dataset
        nc;
    end;
    
    methods
        function o = boot(o)
            
            o.tm = o.tm.boot();
            
            dl = dataloader_scene();
    
            ds = dl.get_basedataset();
            o.nc = ds.nc;
            
            o.k = dl.k; % Cross-validation's "k"

            o.flag_booted = 1;
        end;
        
        
        %> Creates all the tasks
        function o = go(o)
            o = o.boot();
            
            try
                o = o.do_add_all();
                o.tm = o.tm.commit_tasks();
            catch ME
%                 o.tm = o.tm.commit_tasks();
                rethrow(ME);
            end;
        end;
        
        function o = add_all(o)
            o = o.boot();
            try
                o = o.do_add_all();
            catch ME
                rethrow(ME);
            end;
        end;            
    end;
    
    
    methods(Access=protected)
        function o = do_add_all(o)
            
            o = o.boot();
            clwrapper_eff = union(o.clwrapper, o.fhg_fswrapper_cl);
            
            no_clwrapper_eff = numel(clwrapper_eff);
            no_clembedded = numel(o.clembedded);
%             no_fe = numel(o.fe);
            no_fhg_stab = numel(o.fhg_stab);
            no_fhg_others = numel(o.fhg_others);
            no_fhg_fswrapper_fs = numel(o.fhg_fswrapper_fs);
            
            
            
            
            %%%%%%%
            %%%%%%%
            %%%%%%%
            %%%%%%%
            %%%%%%%
            %%%%%%%
            %%%%%%%
            fhgcasenames = {}; % Tokens for foldmerger_fhg
            fhgstabs = {};
            fn_fhgout = {}; idx_fhgout = {}; idx_fearchsel = {}; idx_undersel = {}; idx_clarchsel_em = {}; idx_undersel_em = {};
            for i = 0:iif(o.nc > 2, o.nc-1, 0) % One-versus-reference (OVR) index
                ii = i+1;
                
                fe_now = o.fe;
                if i == 0 && o.nc > 2
                    fe_now(strcmp(fe_now, 'lasso')) = []; % Ok I know that this is a hack, but easy fix and can be easily made general
                end;
                no_fe = numel(fe_now);
                
                %-----> Distribution
%                 nfhg = 0;
                for j = 1:o.k % Cross-validation (CV) index
                    r = 0;
                    for m = 1:no_clwrapper_eff
                        % ClArchSel
                        scl = clwrapper_eff{m};
                        fn_clarchselout{ii, j, m} = o.make_filename('clarchsel', i, j, [], scl); %#ok<*AGROW>
                        [o.tm, idx_clarchsel{ii}(j, m)] = o.tm.add_task(sprintf('goer_clarchsel__%s', scl), '', fn_clarchselout{ii, j, m}, i, j, [], -1);
                        
                        
                        for n = 1:no_fe
                            sfe = fe_now{n};
                            
                            % ---- FearchSel
                            fn_fearchselout{ii, j, m, n} = o.make_filename('fearchsel', i, j, sfe, scl);
                            [o.tm, idx_fearchsel{ii}(j, m, n)] = o.tm.add_task(sprintf('goer_fearchsel_%s', sfe), fn_clarchselout{ii, j, m}, ...
                                fn_fearchselout{ii, j, m, n}, i, j, idx_clarchsel{ii}(j, m), -1);
                        
                            % ---- UnderSel
                            fn_underselout{ii, j, m, n} = o.make_filename('undersel', i, j, sfe, scl);
                            [o.tm, idx_undersel{ii}(j, m, n)] = o.tm.add_task('goer_undersel', fn_fearchselout{ii, j, m, n}, ...
                                fn_underselout{ii, j, m, n}, i, j, idx_fearchsel{ii}(j, m, n), -1);
                        end;

                        % ---- Repeated feature selection
                        if ismember(scl, o.fhg_fswrapper_cl)
                            for iwa = 1:no_fhg_fswrapper_fs
                                s_iwa = o.fhg_fswrapper_fs{iwa};
                                casename = sprintf('%s_%s', s_iwa, scl);
                                for q = 1:no_fhg_stab
                                    stab = o.fhg_stab(q);
                                    r = r+1;
                                    if j == 1
                                        fhgcasenames{ii}{r} = casename;
                                        fhgstabs{ii}{r} = stab;
                                    end;
                                    
                                    fn_fhgout{ii}{j, r} = o.make_filename_fhg('fhg', i, j, stab, casename);
                                    [o.tm, idx_fhgout{ii}(j, r)] = o.tm.add_task(sprintf('goer_fhg_%s', s_iwa), fn_clarchselout{ii, j, m}, fn_fhgout{ii}{j, r}, i, j, idx_clarchsel{ii}(j, m), ...
                                        o.fhg_stab(q));
                                end;
                            end;
                        end;
                    end;
                    
                    % Embedded clarchsel-undersel
                    for m = 1:no_clembedded
                        scl = o.clembedded{m};
                        % Skips feature extraction
                        fn_clarchselout_em{ii, j, m} = o.make_filename('clarchsel', i, j, 'EM', scl);
                        fn_underselout_em{ii, j, m} = o.make_filename('undersel', i, j, 'EM', scl);
                        [o.tm, idx_clarchsel_em{ii}(j, m)] = o.tm.add_task(sprintf('goer_clarchsel__%s', scl), '', fn_clarchselout_em{ii, j, m}, i, j, [], -1);
                        [o.tm, idx_undersel_em{ii}(j, m)] = o.tm.add_task('goer_undersel', fn_clarchselout_em{ii, j, m}, ...
                            fn_underselout_em{ii, j, m}, i, j, idx_clarchsel_em{ii}(j, m), -1);
                    end;
                    
                    for q = 1:no_fhg_others
                        if ~(i == 0 && o.nc > 2 && get_flag_2class(o.fhg_others{q}))
                            r = r+1;
                            casename = o.fhg_others{q};
                            if j == 1
                                fhgcasenames{ii}{r} = casename;
                                fhgstabs{ii}{r} = '-';
                            end;
                            fn_fhgout{ii}{j, r} = o.make_filename_fhg('fhg', i, j, [], casename);
                            [o.tm, idx_fhgout{ii}(j, r)] = o.tm.add_task(sprintf('goer_fhg_%s', o.fhg_others{q}), '', fn_fhgout{ii}{j, r}, i, j, [], -1);
                        end;
                    end;
                end;
                
                %-----> Fold Merging
                
                %--> Estimation of classification performance
                flag_pairwise = i == 0 && o.nc > 2;
                for p = 1:iif(flag_pairwise, 2, 1)
                    spa = iif(p == 1, 'np', 'pa');

                    % First concentrated the cross-validation results into single ones (FOLDMERGER)
                    fn_foldmerger_fitest = {};
                    idx_foldmerger_fitest = [];
                    for m = 1:no_clwrapper_eff
                        scl = clwrapper_eff{m};
                        for n = 1:no_fe
                            sfe = fe_now{n};
                            fn_foldmerger_fitest{m, n} = o.make_filename('foldmerger_fitest', i, j, sfe, scl, p > 1, 0);
                            [o.tm, idx_foldmerger_fitest(m, n)] = o.tm.add_task(['goer_foldmerger_fitest_', spa], fn_underselout(ii, :, m, n), ...
                               fn_foldmerger_fitest{m, n}, i, 0, idx_undersel{ii}(:, m, n), -1);
                        end;
                    end;

                    fn_foldmerger_fitest_em = {};
                    idx_foldmerger_fitest_em = [];
                    for m = 1:no_clembedded
                        scl = o.clembedded{m};
                        fn_foldmerger_fitest_em{m} = o.make_filename('foldmerger_fitest', i, j, 'EM', scl, p > 1, 0);
                        [o.tm, idx_foldmerger_fitest_em(m)] = o.tm.add_task(['goer_foldmerger_fitest_', spa], fn_underselout_em(ii, :, m), ...
                            fn_foldmerger_fitest_em{m}, i, 0, squeeze(idx_undersel_em{ii}(:, m)), -1);
                    end;
                    
                    % Now merges by classifier
                    for m = 1:no_clwrapper_eff
                        scl = clwrapper_eff{m};
                        fns_merger_fitest{1, ii, p, m} = o.make_filename('merger_fitest', i, [], 'ALL', scl, p > 1, 0);
                        [o.tm, idx_merger_fitest(1, ii, p, m)] = o.tm.add_task('goer_merger_fitest', fn_foldmerger_fitest(m, :), fns_merger_fitest{1, ii, p, m}, i, 0, ...
                            idx_foldmerger_fitest(m, :), -1);  
                    end;

                    % Now merges by FE
                    for n = 1:no_fe
                        % Note that embedded classifiers are added to the end for comparison
                        sfe = fe_now{n};
                        fn_merger_fitest = o.make_filename('merger_fitest', i, [], sfe, 'ALL', p > 1, 0);
                        [o.tm, dummy] = o.tm.add_task('goer_merger_fitest', ...
                            [fn_foldmerger_fitest(:, n)', fn_foldmerger_fitest_em], ...
                            fn_merger_fitest, i, 0, ...
                            [idx_foldmerger_fitest(:, n)', idx_foldmerger_fitest_em], -1); %#ok<NASGU>
                    end;
                end;
                
                %--> FHG
                if isempty(fhgcasenames)
                    nfhg = 0;
                else
                    nfhg = numel(fhgcasenames{ii});
                end;
                if nfhg > 0 % total number of FHG cases
                    % First concentrated the cross-validation results into single ones (FOLDMERGER)
                    fn_foldmerger_fhg = {};
                    idx_foldmerger_fhg = [];
                    for r = 1:nfhg
                        
                        casename = fhgcasenames{ii}{r};
                        stab = fhgstabs{ii}{r};
                        fn_foldmerger_fhg{r} = o.make_filename_fhg('foldmerger_fhg', i, [], stab, casename);
                        [o.tm, idx_foldmerger_fhg(r)] = o.tm.add_task('goer_foldmerger_fhg', fn_fhgout{ii}(:, r), fn_foldmerger_fhg{r}, i, 0, idx_fhgout{ii}(:, r), -1);
                    end;

                    fn_merger_fhg = o.make_filename_fhg('merger_fhg', i, [], [], 'ALL');
                    [o.tm, dummy] = o.tm.add_task('goer_merger_fhg', fn_foldmerger_fhg, fn_merger_fhg, i, 0, idx_foldmerger_fhg, -1);  %#ok<NASGU>
                end;
            end;
            irverbose(sprintf('TA: #tasks: %d', size(o.tm.data, 2)), 0);
            
            
            
            
            
            
            %%%%%%%
            %%%%%%%
            %%%%%%%
            %%%%%%%
            %%%%%%%
            %%%%%%%
            %%%%%%%
            % Another OVR loop to add the GrAg (Group Aggregation) tasks
            % This loop has only the merging part
            for i = 0:iif(o.nc > 2, o.nc-1, 0)
                ii = i+1;
                
                fe_now = o.fe;
                if i == 0 && o.nc > 2
                    fe_now(strcmp(fe_now, 'lasso')) = []; % Ok I know that this is a hack, but easy fix and can be easily made general
                end;
                no_fe = numel(fe_now);
                
                %-----> Merging
                
                %--> Estimation of classification performance
                flag_pairwise = i == 0 && o.nc > 2;
                for p = 1:iif(flag_pairwise, 2, 1)
                    spa = iif(p == 1, 'np', 'pa');

                    % First concentrated the cross-validation results into single ones (FOLDMERGER)
                    fn_foldmerger_fitest = {};
                    idx_foldmerger_fitest = [];
                    for m = 1:no_clwrapper_eff
                        scl = clwrapper_eff{m};
                        for n = 1:no_fe
                            sfe = fe_now{n};
                            fn_foldmerger_fitest{m, n} = o.make_filename('foldmerger_fitest', i, [], sfe, scl, p > 1, 1);
                            [o.tm, idx_foldmerger_fitest(m, n)] = o.tm.add_task(['goer_foldmerger_fitest_', spa, '_grag'], fn_underselout(ii, :, m, n), ...
                               fn_foldmerger_fitest{m, n}, i, 0, idx_undersel{ii}(:, m, n), -1);
                        end;
                    end;

                    fn_foldmerger_fitest_em = {};
                    idx_foldmerger_fitest_em = [];
                    for m = 1:no_clembedded
                        scl = o.clembedded{m};
                        fn_foldmerger_fitest_em{m} = o.make_filename('foldmerger_fitest', i, [], 'EM', scl, p > 1, 1);
                        [o.tm, idx_foldmerger_fitest_em(m)] = o.tm.add_task(['goer_foldmerger_fitest_', spa, '_grag'], fn_underselout_em(ii, :, m), ...
                            fn_foldmerger_fitest_em{m}, i, 0, squeeze(idx_undersel_em{ii}(:, m)), -1);
                    end;
                    
                    % Now merges by classifier
                    for m = 1:no_clwrapper_eff
                        scl = clwrapper_eff{m};
                        fns_merger_fitest{2, ii, p, m} = o.make_filename('merger_fitest', i, [], 'ALL', scl, p > 1, 1);
                        [o.tm, idx_merger_fitest(2, ii, p, m)] = o.tm.add_task('goer_merger_fitest', fn_foldmerger_fitest(m, :), fns_merger_fitest{2, ii, p, m}, i, 0, ...
                            idx_foldmerger_fitest(m, :), -1);  
                    end;

                    % Now merges by FE
                    for n = 1:no_fe
                        % Note that embedded classifiers are added to the end for comparison
                        sfe = fe_now{n};
                        fn_merger_fitest = o.make_filename('merger_fitest', i, [], sfe, 'ALL', p > 1, 1);
                        [o.tm, dummy] = o.tm.add_task('goer_merger_fitest', ...
                            [fn_foldmerger_fitest(:, n)', fn_foldmerger_fitest_em], ...
                            fn_merger_fitest, i, 0, ...
                            [idx_foldmerger_fitest(:, n)', idx_foldmerger_fitest_em], -1); %#ok<NASGU>
                    end;
                end;
            end;
            irverbose(sprintf('TA: #tasks: %d', size(o.tm.data, 2)), 0);
            

            
            
            
            
            
            
            %%%%%%%
            %%%%%%%
            %%%%%%%
            %%%%%%%
            %%%%%%%
            %%%%%%%
            %%%%%%%
            for h = 1:2
                sgrag = iif(h == 1, '', '_grag');

                % Yet Another OVR loop to add the merger_merger_fitest tasks
                % This loop has only the merging part
                for i = 0:iif(o.nc > 2, o.nc-1, 0)
                    ii = i+1;

                    flag_pairwise = i == 0 && o.nc > 2;
                    for p = 1:iif(flag_pairwise, 2, 1)
                        spa = iif(p == 1, 'np', 'pa');
                        
                        fn = o.make_filename('merger_merger_fitest', i, [], 'ALL', 'ALL', p > 1, h > 1);
                        [o.tm, idx] = o.tm.add_task('goer_merger_merger_fitest', fns_merger_fitest(h, ii, p, :), ...
                           fn, i, 0, idx_merger_fitest(h, ii, p, :), -1);
                       
                        %One last thing here, the aggregation!
                        fn_com = o.make_filename('commitee', i, [], 'ALL', 'ALL', p > 1, h > 1);
                        [o.tm, dummy] = o.tm.add_task(sprintf('goer_committees_%s%s', spa, sgrag), {fn}, ...
                           fn_com, i, 0, idx, -1); %#ok<NASGU>
                    end;
                end;
            end;
            irverbose(sprintf('TA: #tasks: %d', size(o.tm.data, 2)), 0);

            
            
            
            
            
            %%%%%%% Fold merging for ClArchSel and FeArchSel
            %%%%%%% (to see curves like (number of factors)x(classification rate))
            %%%%%%%
            %%%%%%%
            %%%%%%%
            %%%%%%%
            %%%%%%%
            for i = 0:iif(o.nc > 2, o.nc-1, 0) % One-versus-reference (OVR) index
                ii = i+1;
                
                fe_now = o.fe;
                if i == 0 && o.nc > 2
                    fe_now(strcmp(fe_now, 'lasso')) = []; % Ok I know that this is a hack, but easy fix and can be easily made general
                end;
                no_fe = numel(fe_now);
                

                %-----> Fold Merging to see curves, not estimations
                
                % First concentrated the cross-validation results into single ones (FOLDMERGER)
                for m = 1:no_clwrapper_eff
                    scl = clwrapper_eff{m};

                    % ClArchSel
                    fn_foldmerger_clarchselout{ii, m} = o.make_filename('foldmerger_clarchsel', i, [], [], scl);
                    [o.tm, idx_foldmerger_clarchselout(ii, m)] = o.tm.add_task('goer_foldmerger_items', fn_clarchselout(ii, :, m), fn_foldmerger_clarchselout{ii, m}, ...
                        i, 0, idx_clarchsel{ii}(:, m), -1); %#ok<NASGU>

                    for n = 1:no_fe
                        sfe = fe_now{n};
                        fn_foldmerger_fearchselout = o.make_filename('foldmerger_fearchsel', i, [], sfe, scl);
                        [o.tm, idx_foldmerger_fearchselout(ii, m, n)] = o.tm.add_task('goer_foldmerger_items', fn_fearchselout(ii, :, m, n), ...
                           fn_foldmerger_fearchselout, i, 0, idx_fearchsel{ii}(:, m, n), -1); %#ok<NASGU>
                    end;
                end;

                for m = 1:no_clembedded
                    scl = o.clembedded{m};
                    fn_foldmerger_clarchsel_em = o.make_filename('foldmerger_clarchsel', i, [], 'EM', scl);
                    [o.tm, idx_foldmerger_clarchsel_em] = o.tm.add_task('goer_foldmerger_items', fn_clarchselout_em(ii, :, m), ...
                        fn_foldmerger_clarchsel_em, i, 0, squeeze(idx_clarchsel_em{ii}(:, m)), -1); %#ok<NASGU>
                end;
            end;
                
            irverbose(sprintf('TA: #tasks: %d', size(o.tm.data, 2)), 0);
        end;
    end;

    
    
    methods(Static)
        %> Returns a structure with fields caught from filename + flag_fhg
        %>
        %> Fields correspond parameter names of either make_filename() or
        %> make_filename_fhg()
        %>
        %> @paran fn File name
        %> @param a=struct() Existing structure to add fields to
        function a = parse_filename(fn, a)
            [q, fn, w] = fileparts(fn); %#ok<NASGU,ASGLU>
            if nargin < 2
                a = struct();
            end;
            a.flag_fhg = any(strfind(fn, 'fhg'));
            parts = regexp(fn, '__', 'split');
            parts = parts(2:end); % Skips the "soout"
            % Any elements with a '-' become the '-' themselves
            parts = cellfun(@(x) iif(any(x == '-'), '-', x), parts, 'UniformOutput', 0);
            
            fields = {'ovr', 'cv', 'taskname'};
            if a.flag_fhg
                fields = [fields, {'stab', 'casename'}];
            else
                fields = [fields, {'fename', 'clname', 'pairwise', 'grag'}];
            end;
            for i = 1:numel(fields)
                a.(fields{i}) = parts{i};
            end;
        end;
        
        %> Makes filename from specs for the CLASSIFICATION FRAMEWORK
        %>
        %> @param taskname clarchsel, fearchsel, undersel, foldmerger, merger_fearchsel etc
        %> @param ovr='-' (-, 00, 01 etc) or number
        %> @param cv='-' (-, 01, 02 etc) or number
        %> @param clname='-' -, ALL, ldc, qdc, knn, frbm_kg1, ann, svm, dist etc
        %> @param fename='-' -, ALL, ffs, lasso, fisher etc
        %> @param pairwise='-' -, one, OVO
        %> @param grag='-' (-, row, gro) or boolean
        %> 
        %>
        %> cv and ovr, if given as numbers, will format with 02 digits
        %>
        %> paiwise, if given as number, will eval to OVO/one
        %> grag, if given as numbers, will eval to group/spect
        function fn = make_filename(taskname, ovr, cv, fename, clname, pairwise, grag)
            if nargin < 2 || isempty(cv)
                cv = '-';
            end;
            if nargin < 3 || isempty(ovr)
                ovr = '-';
            end;
            if nargin < 4 || isempty(fename)
                fename = '-';
            end;
            if nargin < 5 || isempty(clname)
                clname = '-';
            end;
            if nargin < 6 || isempty(pairwise)
                pairwise = '-';
            end;
            if nargin < 7 || isempty(grag)
                grag = '-';
            end;
            
            if ~isstr(cv)
                cv = sprintf('%02d', cv);
            end;
            if ~isstr(ovr)
                ovr = sprintf('%02d', ovr);
            end;
            if ~isstr(grag)
                grag = iif(grag, 'group', 'spect');
            end;
            if ~isstr(pairwise)
                pairwise = iif(pairwise, 'OVO', 'one');
            end;
            fn = sprintf('soout__ovr%s__cv%s__%s__%s__%s__%s__%s.mat', ...
                ovr, cv, taskname, fename, clname, pairwise, grag);
        end;      
           
        %> Makes filename from specs for the FHG FRAMEWORK
        %>
        %> @param taskname fhg, foldmerger_fhg, merger_fhg etc
        %> @param stab='-' (-, 00, 02, 05 etc) or number
        %> @param casename ffs_dist, pcalda10 etc
        %>
        %> For other parameter,s @sa make_filename
        function fn = make_filename_fhg(taskname, ovr, cv, stab, casename)
            if nargin < 2 || isempty(cv)
                cv = '-';
            end;
            if nargin < 3 || isempty(ovr)
                ovr = '-';
            end;
            if nargin < 4 || isempty(stab)
                stab = '-';
            end;
            
            if ~isstr(cv)
                cv = sprintf('%02d', cv);
            end;
            if ~isstr(ovr)
                ovr = sprintf('%02d', ovr);
            end;
            if ~isstr(stab)
                stab = sprintf('%02d', stab);
            end;

            fn = sprintf('soout__ovr%s__cv%s__%s__stab%s__%s.mat', ...
                ovr, cv, taskname, stab, casename);
        end;   
    end;
end
