%> @file
%>@ingroup misc

%> @brief Class representing a Confusion matrix.
classdef irconfusion < irlog
    properties
        %> List of all class labels matching the one of the classifier used. It is always used as a reference at least
        %> to renumber the classes of the @c estimato dataset passed to @c do_record() .
        %> least 
        collabels = {};
        %> Grouping of rows in the confusion matrix.
        rowlabels = {};
        %> The matrix itself. The first column must represent rejected items
        C = [];
        %> Whether or not the values are expressed in percentages.
        flag_perc = 1;
        %> =0. Whether to show the "Rejected" column even if there is no rejected item
        flag_force_rejected = 0;
    end;
    
    properties
        %> Whether there is any rejected item, i.e. a nonzero element in the first column. This is automatically calculated
        flag_rejected;
        %> WHether to show the rejected column. Calculated based on @ref flag_force_rejected and @ref flag_rejected
        flag_show_rejected;
    end;
    
    methods
        function flag = get.flag_rejected(o)
            flag = ~isempty(o.C) && any(o.C(:, 1) > 0);
        end;
        
        function flag = get.flag_show_rejected(o)
            flag = o.flag_rejected || o.flag_force_rejected;
        end;
    end;
    
    methods(Access=protected)
        %> Automatically detects if confusion matrix has hits or percentages
        function s = do_get_html(o)
            s = o.get_html_table();
        end;
    end;
	
    methods
        function o = irconfusion()
            o.classtitle = 'Confusion Matrix';
        end;

        function z = get_flag_sortable(o)
            n1 = numel(o.collabels);
            n2 = numel(o.rowlabels);
            z = n1 == n2 && sum(strcmp(o.collabels, o.rowlabels)) == n1;
        end;

        %> Automatically detects if confusion matrix has hits or percentages
        function s = get_html_table(o)
            CC = o.C;
            s = html_confusion(CC, o.rowlabels, o.collabels, o.flag_perc, o.flag_show_rejected);
        end;

        
        %> This sorting is made to group rows/columns. It was used in one of the presentations to Unilever
        %> @param no_levels Number of levels in index key
        function o = sort(o, no_levels)
            if ~o.get_flag_sortable()
                irerror('Cannot sort, collabels and rowslabels are different!');
            end;
            
            if ~exist('no_levels', 'var')
                no_levels = 3;
            end;
            
            n = numel(o.collabels);
            
            CC = o.C(:, 2:end);
            CC2 = CC;
            
            % Normalizes for keymaking
            ma = max(CC(:));
            if ma == 0
                ma = 1;
            end;
            Ctemp = CC(:); Ctemp(Ctemp == 0) = [];
            mi = min(Ctemp);
            CC3 = (CC+eye(n))/ma; % This one just for the key values: diagonals have maximum weight!
            CC = CC/ma; % This one to find the columns to be used as keys
            
            
            ii = 1:numel(o.collabels); %#ok<NASGU>
            iifinal = 1:numel(o.collabels); %#ok<NASGU>
            
            flag_col = 1;
            if flag_col
                dimmax = 1;
            else
                dimmax = 2; %#ok<UNRCH>
            end;

            % Finds a list of columns to use as index keys
            vk = zeros(1, no_levels);
            CCtemp = CC; %#ok<NASGU>
            iitemp = 1:n;
            for j = 1:no_levels
                [vv1, ii1] = max(CC(iitemp, iitemp), [], dimmax); %#ok<NASGU> % column maxima
                [vv2, ii2] = max(vv1);
                vk(j) = iitemp(ii2);
                iitemp(ii2) = [];
            end;


            % Makes a key vector for indexing
            k = zeros(1, n);
            M = 10^(ceil(log10(ma))-log10(mi)+1);
            mult = 1;
            for j = no_levels:-1:1
                if flag_col
                    k = k+mult*CC3(:, vk(j))';
                else
                    k = k+mult*CC3(vk(j), :); %#ok<UNRCH>
                end;
                mult = mult*M;
            end;

            [val, idxs] = sort(k, 'descend');

            o.collabels = o.collabels(idxs); % Somehow stupid since collabels and ...
            o.rowlabels = o.rowlabels(idxs);     % ... rowlabels need be the same, but anyway ...
            CC2 = CC2(idxs, :);
            CC2 = CC2(:, idxs);
            o.C(:, 2:end) = CC2;
        end;

        
        %> Visualization. Draws figure with circles whose area are proportional to the percentuals of the corresponding
        %> cells of the matrix
        function o = draw_balls(o)
            global FONTSIZE;

            FULLDIAM = 0.8; % Diameter of an 100% ball
            MINPERC_BALL = 0.02; % Minimum percentage to draw a ball
            MINPERC_TEXT = 0.1; % Minimum percentage to write percentage text
            
            Ccalc = o.C;
            Cshow = Ccalc;
            [ni, nj] = size(Ccalc);
            
            % What to show
            sperc = '';
            if o.flag_perc
                sperc = '%';
                Cshow = round(Cshow*100)/100; % To make 2 decimal places only
            end;
            
            % What to use for calculation (normalizes to 0-1)
            Ccalc = normalize_rows(Ccalc);
            
            % Makes header strings.
            c = ['rejected' o.collabels];
            

            % Other calculations
            yspacing = 1.3;
            xlim = [0, nj+1-(1-o.flag_show_rejected)]; % x-limits
            ylim = [0, (ni-1)*yspacing+2]; 
            flag_same = compare(o.collabels, o.rowlabels);
            
            hh = [];
            hh2 = [];
            hhtext1 = [];
            hhtext2 = [];
            for i = 1:ni % row loop
                
                ypos = (i-1)*yspacing+1;

                plot(xlim, ypos*[1, 1], 'k', 'LineWidth', scaled(3)); % Horizontal line
                hold on;
                hh(end+1) = text(xlim(1)-0.1, ypos, o.rowlabels{i}, 'HorizontalAlignment', 'right'); % Descriptive text
                hhtext1(end+1) = hh(end);
                
                k = 0; % graphics column (whereas j is the matrix column)
                for j = iif(o.flag_show_rejected, 1, 2):nj % column loop
                    k = k+1;
                    
                    if i == 1
                        hh(end+1) = text(k, -0.1, c{j}, 'HorizontalAlignment', 'right', 'Rotation', 270);
                        hhtext2(end+1) = hh(end);

%                         plot(k*[1, 1], ylim, 'k', 'LineWidth', scaled(3)); % Vertical line
                    end;

                    if Ccalc(i, j) > MINPERC_BALL
                        diam = sqrt(FULLDIAM*Ccalc(i, j));
                        pos = [k-diam/2, ypos-diam/2, diam, diam];
                        if j == 1
                            color_ = [1, 1, 1]*.3;
                        elseif flag_same
                            if i == j-1
                                color_ = [0, 0.7, 0];
                            else
                                color_ = [1, 0, 0];
                            end;
                        else
                            color_ = find_color(j-1);
                        end;
                        rectangle('Position', pos, 'LineStyle', '-', 'LineWidth', scaled(2), 'FaceColor', color_, 'Curvature', [1, 1]);%, 'LineColor', 'k');

                        if Ccalc(i, j) >= MINPERC_TEXT
                            hh2(end+1) = text(k, ypos-diam/2, [sprintf('%g', Cshow(i, j)), sperc], 'HorizontalAlignment', 'center', 'VerticalAlignment', 'bottom');
                        end;
                    end;
                end;
            end;
            plot(xlim([1, 2, 2, 1, 1]), ylim([1, 1, 2, 2, 1]), 'Color', [0, 0, 0], 'LineWidth', scaled(2)); % Box

            axis equal;
            axis off;
            set(gca, 'YDir', 'reverse');
            set(gca, 'XTick', [], 'YTick', []);
            format_frank(gcf, 1, [hh, hh2]);
            for i = 1:numel(hh2)
                set(hh2, 'FontSize', FONTSIZE*scaled(.75));
            end;
            
            % Let's attempt to make all the ticks/(row/column titles)/(class labels) to appear
            maximize_window([], 1, .9); % Have to do this, because the Extent property below gives values relative to the gca(), and this changes according to the size of the figure on screen
            pause(0.2); % Has to wait until the window maximization takes place
            maxwid = -Inf;
            for i = 1:ni
%                 set(hhtext1(i), 'Unit', 'Normalized');
                p = get(hhtext1(i), 'Extent');
                maxwid = max([maxwid, p(3)]);
            end;
            maxhei = -Inf;
            for i = 1:numel(hhtext2)
%                 set(hhtext2(i), 'Unit', 'Normalized');
                p = get(hhtext2(i), 'Extent');
                maxhei = max([maxhei, p(4)]);
            end;
            
            xlim(1) = xlim(1)-maxwid-0.1;
            ylim(1) = ylim(1)-maxhei-0.1;
            
            set(gca, 'Xlim', xlim, 'YLim', ylim, 'position', [0.025, 0.025, 0.95, 0.95]);
%             
%             maxhei = -Inf;
%             for i = 1:ni
% %                 set(hhtext2(i), 'Unit', 'Normalized');
%                 p = get(hhtext2(i), 'Extent');
%                 maxhei = max([maxhei, p(4)]);
%             end;
%             
%             
%             totalwid = maxwid+1;
%             totalhei = maxhei+1;
%             x = maxwid/totalwid;
%             y = maxhei/totalhei;
%             
%             p = get(gca, 'Position');
%             p(1) = x;
%             p(3) = 1-x;
%             p(2) = 0.025;
%             p(4) = .975-y;
%             if all(p([2, 4]) > 0)
%                 set(gca, 'Position', p);
%             end;
%                 
        end;
    end;
end
