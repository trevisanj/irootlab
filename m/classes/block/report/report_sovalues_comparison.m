%> @brief Comparison and p-values tables
classdef report_sovalues_comparison < irreport
    properties
        %> ={[Inf, 0, 0], [1, 2]}
        %> @sa sovalues.m
        dimspec = {[0, 0], [1, 2]};

        %> =1. Whether to generate the p-values tables
        flag_ptable = 1;
        
        %> ={'rates', 'times3'}
        %>
        %> The first element will be assumed to be the classification rate and used to choose one row as best
        names = {'rates', 'times3'};
        
        %> vectorcomp_ttest_right() with no logtake. vectorcomp object used tor the p-values tables
        vectorcomp = [];

        %> Maximum number of table rows
        maxrows = 20;
    end;

    methods
        function o = report_sovalues_comparison()
            o.classtitle = 'Flat comparison table';
            o.inputclass = 'sovalues';
            o.flag_params = 1;
        end;
    end;
    
    methods(Access=protected)
        function out = do_use(o, sov)
            out = log_html();
            out.html = ['<h1>', sov.title, '</h1>', 10, o.get_html_tables(sov)];
            out.title = sov.get_description();
        end;
    end;

    
    methods
        %> Generates a table with the best in each architecture, with its respective time and confidence interval
        %> @param sov sovalues object
        function s = get_html_tables(o, sov)
            s = '';
            if isempty(sov)
                return;
            end;

            if isempty(o.vectorcomp)
                o.vectorcomp = vectorcomp_ttest_right();
                o.vectorcomp.flag_logtake = 0;
            end;
            
            [values, ax] = sovalues.get_vv_aa(sov.values, sov.ax, o.dimspec);
            
            flag_rejected = isfield(values(1), 'oc') && values(1).oc.flag_rejected;
            ratess = sovalues.getYY(values, o.names{1});
            if size(ratess, 2) > 1
                irerror('I cannot handle results that have more than one column!', 2);
            end;
            
            temp = permute(ratess, [3, 1, 2]);
            rates = mean(temp, 1);
            if isfield(values, 'times3')
                ratessort = rates-std(temp)/1e7-mean(permute(sovalues.getYY(values, 'times3'), [3, 1, 2]), 1)/1e10; % Just to solve ties: if the rate is the same, chooses one with lower standard deviation
            else
                ratessort = rates-std(temp)/1e7; % Just to solve ties: if the rate is the same, chooses one with lower standard deviation
            end;
            [vv, ii] = sort(ratessort, 'descend'); %#ok<ASGLU>
            values = values(ii);
            if isempty(sov.chooser)
                choiceidx = [];
            else
                idxs = sov.chooser.use(values);
                choiceidx = idxs{1};
            end;
            nnames = numel(o.names);
            nar = numel(values);
            R = permute(squeeze(sovalues.getYY(values, o.names{1})), [2, 1]);
            if nar > o.maxrows
                ii = o.some_items(nar, choiceidx);
            else
                ii = 1:nar;
            end;

            R = R(:, ii);
            Mp = o.vectorcomp.crosstest(R); % Matrix for the p-values (last column) of the firts table
            
            flag_choice = ~isempty(choiceidx);
            choiceheader = '';
            if flag_choice
                choiceheader = ['<td class="bob">&nbsp;</td>', 10];
            end;
            
            %>>>>> HTML
            
            %>>> Table header
            s0 = '';
            s0 = cat(2, s0, '<center><table class=bo>', 10, '<tr>', 10, choiceheader, ...
                '<td class="bob"><div class="hel">#</div></td>', 10, ...
                '<td class="bob"><div class="hel">System</div></td>', 10);
            
            for i = 1:nnames
                s0 = cat(2, s0, '<td class="bob"><div class="hec">', labeldict(o.names{i}), '</div></td>', 10);
            end;
% (04/07/2013) Examiners didn't like this column            s0 = cat(2, s0, '<td class="bob"><div class="hec"><em>p</em>-values', '</div></td>', 10);
            if flag_rejected
                s0 = cat(2, s0, '<td class="bob"><div class="hec">Refused (%)</div></td>', 10);
            end;
            s0 = cat(2, s0, '</tr>', 10);
            
            
            %>>> Table Body
            ni = min(o.maxrows, nar);
            for i = 1:ni
                s0 = cat(2, s0, '<tr>', 10);
                
                clad = '';
                if flag_choice
                    flag_chosen = ~isempty(choiceidx) && choiceidx == ii(i);
                    clad = iif(flag_chosen, 'choa', '');
                    
                    s0 = cat(2, s0, sprintf('<td class="hel%s">', clad), iif(flag_chosen, '&raquo;', '&nbsp;'), '</td>', 10);
                end;
                
                s0 = cat(2, s0, sprintf('<td class="hel%s">', clad), int2str(ii(i)), '</td>', 10);
                if isfield(values, 'spec')
                    s0 = cat(2, s0, sprintf('<td class="hel%s">', clad), values(ii(i)).spec, '</td>', 10);
                else
                    s0 = cat(2, s0, sprintf('<td class="hel%s">', clad), 'spec?', '</td>', 10);
                end;
                 
                for j = 1:nnames
                    v = values(ii(i)).(o.names{j});
                    
                
                    mv = mean(v);
%                     civ = confint(v);
%                     civ = civ(end)-mv;
                    civ = std(v); % Let's make standard deviation the standard for +- specifications
                
                    s0 = cat(2, s0, sprintf('<td class="nu%s">', clad), sprintf('%.2f &plusmn; %.2f', mv, civ), '</td>', 10);
                end;

                
% (04/07/2013) Examiners didn't like this column
%                 % P-value column
%                 if i == ni
%                     stemp = '-';
%                 else
%                     x = Mp(i, i+1);
%                     stemp = iif(x < 0.001, '< 0.001', sprintf('%.3f', x));
%                 end;
%                 s0 = cat(2, s0, sprintf('<td class="nu%s">', clad), stemp, '</td>', 10);
                
                % Rejected column
                if flag_rejected
                    s0 = cat(2, s0, sprintf('<td class="nu%s">%.2f</td>', clad, 100*mean(values(ii(i)).oc.C(:, 1))), 10);
                end;
                
                s0 = cat(2, s0, '</tr>', 10);
            end;
            s0 = cat(2, s0, '</table></center>', 10);


            s1 = '';
            if o.flag_ptable
                s1 = cat(2, s1, '<h4><em>p</em>-values tables</h4>', 10, '<p>Vector comparer object: <b>', ...
                    o.vectorcomp.get_description(0), ' (<a href="matlab:edit(''', class(o.vectorcomp), '.m'')">', class(o.vectorcomp), '</a>)</b></p>');
                for i = 1:nnames
                    R = permute(squeeze(sovalues.getYY(values, o.names{i})), [2, 1]);
                    R = R(:, ii);
                    M = o.vectorcomp.crosstest(R);

                    if ~labeldict(o.names{i}, 1)
                        % Higher is better
                        B = M < M';
                        B = B + (B & M < 0.05)*2;
                    else
                        % Lower is better
                        B = M > M';
                        B = B + (B & M > 0.95)*2;
                    end;

                    M = arrayfun(@(x) iif(x == 0, '-', iif(x < 0.001, '< 0.001', sprintf('%.3f', x))), M, 'UniformOutput', 0);

                    s1 = cat(2, s1, '<h5><em>p</em>-values for ', labeldict(o.names{i}), '</h5>', 10, '<center>', ...
                        html_comparison(M, arrayfun(@int2str, ii, 'UniformOutput', 0), B), '</center>', 10);
                end;            
            end;
            
            s = '';
            s = cat(2, s, '<h4>Comparison table</h5>', 10, s0, 10, s1, 10);
        end;
    end;
    
    methods
        %> @return Indexes of some elements
        %>
        %> The number of elements that will figure in the tables is limited by the @c maxrows property. This function returns the indexes of some elements
        %> around the chosen one (if any was chosen), otherwise returns maxrows elements, starting at the first.
        function v = some_items(o, nar, choiceidx)
            if isempty(choiceidx)
                v = 1:o.maxrows;
            else
                A = .4;
%                 share1 = A;
                share2 = 1-A; % percentages of items destinated for the first items and items around choiceidx respectively

                nit = min(o.maxrows, nar);

                i1 = floor(choiceidx-share2/2*nit);
                i2 = ceil(choiceidx+share2/2*nit);
                i0 = nit-((i2-i1)+1);

                if i1 <= i0
                    dif = i0-i1+1;
                    i1 = i1+dif;
                    i2 = i2+dif;
                end;

                if i2 > nar;
                    dif = i2-nar;
                    i1 = i1-dif;
                    i2 = i2-dif;
                end;

                v = [1:i0, i1:i2];
            end;
        end;
    end;
end
