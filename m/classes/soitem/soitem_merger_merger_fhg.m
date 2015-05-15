%> Items is an array of soitem_merger_fhg
%>
%> Not sure it this applies: In this type of SODATAITEM, the sovalues object contains a values.dia field
classdef soitem_merger_merger_fhg < soitem
    properties
        %> Array of soitem_merger_fhg objects
        items = soitem_merger_fhg.empty();
    end;
    
    % -*-*-*-*-*- TOOLS
    methods
        %> @param varargin see @ref get_biocomparisontable
        %> @return [s, M, titles] @s is HTML; M is the comparison cube; @c titles describes each row in M
        %>
        %> @sa get_biocomparisoncube()
        function [s, M, titles] = html_biocomparisontable(o, varargin)
            [M, titles] = o.get_biocomparisoncube(varargin{:});
            means = mean(M, 3);
            stds = std(M, [], 3);
            s = ['<center>', html_comparison_std(round(means*100)/100, round(stds*100)/100, titles), '</center>', 10];
        end;
        
        %> @param varargin see @ref get_biocomparisontable
        %> @return [s, M, titles] @s is HTML; M is the comparison cube; @c titles describes each row in M
        %>
        %> @sa get_biocomparisoncube_nf4grades()
        function [s, M, titles] = html_biocomparisontable_nf4grades(o, varargin)
            [M, titles] = o.get_biocomparisoncube_nf4grades(varargin{:});
            means = mean(M, 3);
            stds = std(M, [], 3);
            s = ['<center>', html_comparison_std(round(means*100)/100, round(stds*100)/100, titles), '</center>', 10];
        end;
        
        %> @param varargin see @ref get_biocomparisontable
        %> @return [s, M, titles] @s is HTML; M is the comparison cube; @c titles describes each row in M
        %>
        %> @sa get_biocomparisoncube_ssps()
        function [s, M, titles] = html_biocomparisontable_ssps(o, varargin)
            [M, titles] = o.get_biocomparisoncube_ssps(varargin{:});
            means = mean(M, 3);
            stds = std(M, [], 3);
            s = ['<center>', html_comparison_std(round(means*100)/100, round(stds*100)/100, titles), '</center>', 10];
        end;
        
        %> @param varargin see @ref get_biocomparisontable
        %> @return [s, M, titles] @s is HTML; M is the comparison cube; @c titles describes each row in M
        %>
        %> @sa get_biocomparisoncube_stab()
        function [s, M, titles] = html_biocomparisontable_stab(o, varargin)
            [M, titles] = o.get_biocomparisoncube_stab(varargin{:});
            means = mean(M, 3);
            stds = std(M, [], 3);
            s = ['<center>', html_comparison_std(round(means*100)/100, round(stds*100)/100, titles), '</center>', 10];
        end;
        
        %> @param varargin see @ref get_nf4grades
        function s = html_nf4grades(o, varargin)
            [M, titles] = o.get_nf4grades(varargin{:});
            means = mean(M, 2);
            stds = std(M, [], 2);
            s = ['<center>', html_table_std(round(means*100)/100, round(stds*100)/100, titles, {'nf4grades'}), '</center>', 10];
        end;
        
           
        %> Returns description of idx-th log
        function s = get_logdescription(o, idx)
            s = o.s_methodologies{idx};
            if o.items(1).stabs(idx) >= 0
                s = [s, '&Stab', sprintf('%02d', o.items(1).stabs(idx))];
            end;
        end;
    end;        
        
        
        
        
    
    %------> Low-level tools
    methods
        %> @param idxs Indexes within <code>o.items(i).logs</code>
        %> @param ssp A subsetsprocessor object
        %> @param pd A peakdetector object
        %> @param bc A biocomparer object
        %>
        %> @return [M, titles] @c M is a [no_idxs]x[no_idxs]x[no_items] matrix
        function [M, titles] = get_biocomparisoncube(o, idxs, ssp, pd, bc)
            if nargin < 4 || isempty(pd)
                pd = def_peakdetector();
            end;
            if nargin < 5 || isempty(bc)
                bc = def_biocomparer();
            end;
            
            nitems = numel(o.items);
            nidxs = numel(idxs);
            M = zeros(nidxs, nidxs, nitems);
            
            for i = 1:nitems
                [M(:, :, i), temp] = o.items(i).get_biocomparisontable(idxs, ssp, pd, bc);
                if i == 1
                    titles = temp;
                end;
            end;
        end;
        

        %> @return [M, titles] @M is a [nf4gradesmax]x[nf4gradesmax]x[no_idxs*no_items] matrix
        function [M, titles] = get_biocomparisoncube_nf4grades(o, idxs, ssp, pd, bc)
            if nargin < 3 || isempty(pd)
                pd = def_peakdetector();
            end;
            if nargin < 4 || isempty(bc)
                bc = def_biocomparer();
            end;

            M = [];
            for i = 1:numel(o.items)
                [temp_M, temp_titles] = o.items(i).get_biocomparisontable_nf4grades(idxs, ssp, pd, bc);
                if i == 1
                    titles = temp_titles;
                end;
                M = cat(3, M, temp_M);
            end;
        end;


        %> @return [M, titles] @M is a [nf4gradesmax]x[nf4gradesmax]x[no_idxs*no_items] matrix
        function [M, titles] = get_biocomparisoncube_ssps(o, idxs, ssps, pd, bc)
            if nargin < 3 || isempty(pd)
                pd = def_peakdetector();
            end;
            if nargin < 4 || isempty(bc)
                bc = def_biocomparer();
            end;

            M = [];
            for i = 1:numel(o.items)
                [temp_M, temp_titles] = o.items(i).get_biocomparisontable_ssps(idxs, ssps, pd, bc);
                if i == 1
                    titles = temp_titles;
                end;
                M = cat(3, M, temp_M);
            end;
        end;

        %> @return [M, titles] @M is a [no_stabs]x[no_stabs]x[no_methodologies*no_items] matrix
        function [M, titles] = get_biocomparisoncube_stab(o, ssp, pd, bc)
            if nargin < 2 || isempty(pd)
                pd = def_peakdetector();
            end;
            if nargin < 3 || isempty(bc)
                bc = def_biocomparer();
            end;

            M = [];
            for i = 1:numel(o.items)
                [temp_M, temp_titles] = o.items(i).get_biocomparisontable_stab(ssp, pd, bc);
                if i == 1
                    titles = temp_titles;
                end;
                M = cat(3, M, temp_M);
            end;
        end;

        
        %> Generates a vector of "Number of features for grades" matrix
        %>
        %> @param idxs Indexes within <code>o.items(i).logs</code>
        %> @param ssp A subsetsprocessor object
        %>
        %> @return [M, titles] @c M is a [no_idxs]x[no_items] matrix
        function [M, titles] = get_nf4grades(o, idxs, ssp)
            nitems = numel(o.items);
            nidxs = numel(idxs);
            M = zeros(nidxs, nitems);
            ipro = progress2_open('GET_NF4GRADES', [], 0, nitems);
            for h = 1:nitems
                [M(:, h), temp] = o.items(h).get_nf4grades(idxs, ssp);
                if h == 1
                    titles = temp;
                end;
                ipro = progress2_change(ipro, [], [], h);
            end;
            progress2_close(ipro);
        end;
        
        
        %> Wrapper to <code>o.items(1).find_methodologygroups()</code>
        function groupidxs = find_methodologygroups(o)
            groupidxs = o.items(1).find_methodologygroups();
        end;
        
        %> Wrapper to <code>o.items(1).find_stab()</code>
        function idxs = find_stab(o, stab)
            idxs = o.items(1).find_stab(stab);
        end;

        %> Wrapper to <code>o.items(1).single()</code>
        function idxs = find_single(o)
            idxs = o.items(1).find_single();
        end;
        
        %> @brief Stores stabilities vector within the @ref log_fselrepeater objects to prevent frequent recalculation
        %> @param ssp subsetsprocessor object
        function o = calculate_stabilities(o, ssp)
            ipro = progress2_open('CALCULATE_STABILITIES', [], 0, numel(o.items));
            for i = 1:numel(o.items)
                o.items(i) = o.items(i).calculate_stabilities(ssp);
                ipro = progress2_change(ipro, [], [], i);
            end;
            progress2_close(ipro);
        end;
    end;
end
