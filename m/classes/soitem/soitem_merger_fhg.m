%> In this type of SODATAITEM, the sovalues object contains a values.dia field
classdef soitem_merger_fhg < soitem
    properties
        s_methodologies;
        stabs;
        %> Array of log_fselrepeater objects
        logs;
    end;
    
    % -*-*-*-*-*- TOOLS
    methods
        %> Generates an HTML table with the log-wise Biomarker Coherence Indexes
        %>
        %> @param varargin see @ref get_biocomparisontable
        function s = html_biocomparisontable(o, varargin)
            [M, titles] = o.get_biocomparisontable(varargin{:});
            s = ['<center>', html_comparison(round(M*1000)/1000, titles), '</center>', 10];
        end;
        
        %> Generates an HTML table with the nf4grades-wise Biomarker Coherence Indexes
        %>
        %> @param varargin see @ref get_biocomparisontable_nf4grades
        function [s, M, titles] = html_biocomparisontable_nf4grades(o, varargin)
            [M, titles] = o.get_biocomparisontable_nf4grades(varargin{:});
            means = mean(M, 3);
            stds = std(M, [], 3);
            s = ['<center>', html_comparison_std(round(means*100)/100, round(stds*100)/100, titles), '</center>', 10];
        end;
           
        %> Generates an HTML table with the nf4grades-wise Biomarker Coherence Indexes
        %>
        %> @param varargin see @ref get_biocomparisontable_nf4grades
        function [s, M, titles] = html_biocomparisontable_ssps(o, varargin)
            [M, titles] = o.get_biocomparisontable_ssps(varargin{:});
            means = mean(M, 3);
            stds = std(M, [], 3);
            s = ['<center>', html_comparison_std(round(means*100)/100, round(stds*100)/100, titles), '</center>', 10];
        end;
   
        %> Generates an HTML table with the stab-wise Biomarker Coherence Indexes
        %>
        %> @param varargin see @ref get_biocomparisontable_nf4grades
        function [s, M, titles] = html_biocomparisontable_stab(o, varargin)
            [M, titles] = o.get_biocomparisontable_stab(varargin{:});
            means = mean(M, 3);
            stds = std(M, [], 3);
            s = ['<center>', html_comparison_std(round(means*100)/100, round(stds*100)/100, titles), '</center>', 10];
        end;
        
        %> @param varargin see @ref get_nf4grades
        function s = html_nf4grades(o, varargin)
            [M, titles] = o.get_nf4grades(varargin{:});
            M = M(:);
%             stds = std(M, [], 2);
%             s = ['<center>', html_table_std(round(means*100)/100, round(stds*100)/100, titles, {'nf4grades'}), '</center>', 10];
            s = ['<center>', html_table_std(M, [], titles, {'Number of informative features'}), '</center>', 10];
        end;
        
           
        %> Returns description of idx-th log
        function s = get_logdescription(o, idx)
            s = o.s_methodologies{idx};
            if o.stabs(idx) >= 0
                s = [s, '-stab', sprintf('%02d', o.stabs(idx))];
            end;
        end;
    end;        
        
        
        
        
    
    %------> Low-level tools
    methods
        %> Generates a matrix of item-wise Biomarkers Coherence Indexes
        %>
        %> @param idxs Indexes within @ref logs
        %> @param ssp A subsetsprocessor object
        %> @param pd A peakdetector object
        %> @param bc A biocomparer object
        %>
        %> @return [M, titles]
        function [M, titles] = get_biocomparisontable(o, idxs, ssp, pd, bc)
            if nargin < 4 || isempty(pd)
                pd = def_peakdetector();
            end;
            if nargin < 5 || isempty(bc)
                bc = def_biocomparer();
            end;
            
            no = numel(idxs);
            for i = 1:no
                log_rep = o.logs(idxs(i));
                hist = ssp.use(log_rep);

                pd = pd.boot(hist.fea_x, hist.grades);

                % Collects biomarkers
                pdidxs = pd.use([], hist.grades);
                wnss{i} = hist.fea_x(pdidxs);
                weightss{i} = hist.grades(pdidxs);
                titles{i} = o.get_logdescription(idxs(i));
            end;

            % + Mounts table
            M = eye(no);
            for i = 1:no
                for j = i+1:no
                    [matches, index] = bc.go(wnss{i}, wnss{j}, weightss{i}, weightss{j}); %#ok<ASGLU>
                    M(i, j) = index;
                    M(j, i) = index;
                end;
            end;
        end;
        

        
        %> Generates a matrix of nf4grades-wise Biomarkers Coherence Indexes
        %>
        %> @param idxs Indexes within @ref logs
        %> @param ssp Subsetsprocessor object
        %> @param pd A peakdetector object
        %> @param bc A biocomparer object
        %>
        %> @return [M, titles] @M is a [nf4gradesmax]x[nf4gradesmax]x[no_idxs] matrix
        function [M, titles] = get_biocomparisontable_nf4grades(o, idxs, ssp, pd, bc)
            if nargin < 3 || isempty(pd)
                pd = def_peakdetector();
            end;
            if nargin < 4 || isempty(bc)
                bc = def_biocomparer();
            end;

            n = numel(idxs);
            
            % Finds maximum nf4grades
            nf4gradesmax = Inf;
            for i = 1:n
                nf4gradesmax = min(o.logs(idxs(i)).nfmax, nf4gradesmax);
            end;
            
            ssp.nf4gradesmode = 'fixed';

            M = repmat(eye(nf4gradesmax), [1, 1, n]);
            for i = 1:n
                log_rep = o.logs(idxs(i));
                for j = 1:nf4gradesmax
                    if i == 1
                        titles{j} = sprintf('%d', j);
                    end;
                    ssp.nf4grades = j;
                    hist = ssp.use(log_rep);
                    pd = pd.boot(hist.fea_x, hist.grades);

                    % Collects biomarkers
                    pdidxs = pd.use([], hist.grades);
                    wnss{j} = hist.fea_x(pdidxs);
                    weightss{j} = hist.grades(pdidxs);
                end;

                % + Mounts table
                for j = 1:nf4gradesmax
                    for k = j+1:nf4gradesmax
                        [matches, index] = bc.go(wnss{j}, wnss{k}, weightss{j}, weightss{k}); %#ok<ASGLU>
                        M(j, k, i) = index;
                        M(k, j, i) = index;
                    end;
                end;
            end;
        end;        
        
        
        
        %> Generates a matrix of subsetsprocessor-wise Biomarkers Coherence Indexes
        %>
        %> @param idxs Indexes within @ref logs
        %> @param ssps Subsetsprocessor cell
        %> @param pd A peakdetector object
        %> @param bc A biocomparer object
        %>
        %> @return [M, titles] @M is a [nf4gradesmax]x[nf4gradesmax]x[no_idxs] matrix
        function [M, titles] = get_biocomparisontable_ssps(o, idxs, ssps, pd, bc)
            if nargin < 3 || isempty(pd)
                pd = def_peakdetector();
            end;
            if nargin < 4 || isempty(bc)
                bc = def_biocomparer();
            end;

            nidxs = numel(idxs);
            nssps = numel(ssps);
            

            M = repmat(eye(nssps), [1, 1, nidxs]);
            for i = 1:nidxs
                log_rep = o.logs(idxs(i));
                for j = 1:nssps
                    ssp = ssps{j};
                    if i == 1; titles{j} = ssp.title; end;
                    hist = ssp.use(log_rep);
                    pd = pd.boot(hist.fea_x, hist.grades);

                    % Collects biomarkers
                    pdidxs = pd.use([], hist.grades);
                    wnss{j} = hist.fea_x(pdidxs);
                    weightss{j} = hist.grades(pdidxs);
                end;

                % + Mounts table
                for j = 1:nssps
                    for k = j+1:nssps
                        [matches, index] = bc.go(wnss{j}, wnss{k}, weightss{j}, weightss{k}); %#ok<ASGLU>
                        M(j, k, i) = index;
                        M(k, j, i) = index;
                    end;
                end;
            end;
        end;        
        
        %> Generates a matrix of stab-wise Biomarkers Coherence Indexes
        %>
        %> @param pd A peakdetector object
        %> @param bc A biocomparer object
        %>
        %> @return [M, titles] @M is a [no_stabs]x[no_stabs]x[no_methodologies] matrix
        function [M, titles] = get_biocomparisontable_stab(o, ssp, pd, bc)
            if nargin < 3 || isempty(pd)
                pd = def_peakdetector();
            end;
            if nargin < 4 || isempty(bc)
                bc = def_biocomparer();
            end;

            groupidxs = o.find_methodologygroups();
            no_groups = numel(groupidxs);
            no_stabs = numel(groupidxs{1}); 
            
            M = repmat(eye(no_stabs), [1, 1, no_groups]);
            for i = 1:no_groups
                for j = 1:no_stabs
                    idx = groupidxs{i}(j);
                    log_rep = o.logs(idx);
                    if i == 1
                        titles{j} = sprintf('stab%02d', o.stabs(idx));
                    end;
                    hist = ssp.use(log_rep);
                    pd = pd.boot(hist.fea_x, hist.grades);

                    % Collects biomarkers
                    pdidxs = pd.use([], hist.grades);
                    wnss{j} = hist.fea_x(pdidxs);
                    weightss{j} = hist.grades(pdidxs);
                end;

                % + Mounts table
                for j = 1:no_stabs
                    for k = j+1:no_stabs
                        [matches, index] = bc.go(wnss{j}, wnss{k}, weightss{j}, weightss{k}); %#ok<ASGLU>
                        M(j, k, i) = index;
                        M(k, j, i) = index;
                    end;
                end;
            end;
        end;        
        
        
        %> Generates a vector of "Number of features for grades vector"
        %>
        %> @param idxs Indexes within @ref logs
        %> @param ssp A subsetsprocessor object
        %>
        %> @return [v, titles]
        function [v, titles] = get_nf4grades(o, idxs, ssp)
            no = numel(idxs);
            v = zeros(1, no);
            for i = 1:no
                log_rep = o.logs(idxs(i));
                v(i) = ssp.get_nf4grades(log_rep);
                titles{i} = o.get_logdescription(idxs(i));
            end;
        end;

        
        
        
        %> Returns a cell of indexes. Within the cell, each element is a vector of indexes representing variants of the same methodology
        function groupidxs = find_methodologygroups(o)
            groupidxs = {};
            mm = o.s_methodologies;
            un = unique(mm);
            nun = numel(un);
            
            for i = 1:nun
                b = strcmp(un{i}, mm);
                nm(i) = sum(b);
                groupidxs{i} = find(b);
            end;
            groupidxs = groupidxs(nm > 1); % Removes "groups" with single item
        end;
        
        %> Returns the indexes of the elemens that have stab=@c stab
        function idxs = find_stab(o, stab)
            idxs = find(o.stabs == stab);
        end;

        %> Returns the indexes of the elements that are the sole representants of their respective methodologies
        function idxs = find_single(o)
            groupidxs = {};
            mm = o.s_methodologies;
            un = unique(mm);
            nun = numel(un);
            
            for i = 1:nun
                b = strcmp(un{i}, mm);
                nm(i) = sum(b);
                groupidxs{i} = find(b);
            end;
            groupidxs = groupidxs(nm == 1); % Keeps only "groups" with single item
            idxs = [groupidxs{:}];
        end;
        
        %> @brief Stores stabilities vector within the @ref log_fselrepeater objects to prevent frequent recalculation
        %> @param ssp subsetsprocessor object
        function o = calculate_stabilities(o, ssp)
            for i = 1:numel(o.logs)
                o.logs(i) = o.logs(i).calculate_stabilities(ssp.stabilitytype, 'uni');
            end;
        end;
    end;
end