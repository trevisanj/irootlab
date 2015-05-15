%> @ingroup graphicsapi
%>
%> @brief BioMarker Table
%>
%> This is old code that is still in use for its ability to draw the "Peak Location" plots
%>
%> It was originally a class to facilitate biomarker comparison between different datasets/methods. It can draw the
%> "grades" curves (e.g. loadings, p-values, feature frequency histograms) and Peak Location Plots thereof.
%>
%> It needs a lot of setup to work, so it is probably better to use @ref draw_loadings_pl.m instead. The classes @ref vis_loadings and
%> have an option to visualize loadings/grades vectors as "Peak Location" plots @ref vis_log_grades
%>
%> If want to use this class directly, use @ref demo_bmtable.m as a template to perform the following settings:
%> <ol>
%>   <li>Assign @c blocks, @c datasets, @c peakdetectors, @c arts, @c units, and @c data_hint (optional)</li>
%>   <li>Setup the @c grid property</li>
%>   <li>Call draw_pl() or draw_lines()</li>
%> </ol>
%>
%> @sa draw_loadings_pl.m, demo_bmtable.m
%>
classdef bmtable
    properties
        %> 2D struct
        %>
        %> @c i_block, @c i_dataset, @c i_peakdetector, @c i_art, @c i_unit point to elements in respective properties;
        %> @c flag_sig indicated whether to draw significance threshold line; @c params if passed to get_gradeslegend() and
        %> get_grades() (please note: post-training!); @c peakidxs, @c peak_y, @c y are calculated with shake_grid().
        grid = struct('i_block', {}, 'i_dataset', {}, 'i_peakdetector', {}, 'i_art', {}, 'i_unit', {}, 'params', {}, 'flag_sig', {}, ...
                      'peakidxs', {}, 'peak_y', {}, 'y', {});
        %> array of irdata.
        %>
        %> datasets are used only if @ref rowname_type is 'dataset'. They are used to get row names (will be dataset.title)
        %>
        %> If not used, <code>grid.i_dataset</code> will be irrelevant.
        datasets;
        %> Cell of @ref block objects
        blocks;
        %> Cell of @ref peakdetector objects
        peakdetectors;
        %> Cell of @ref bmart objects
        arts;
        %> Cell of @ref bmunit objects
        units;
        %> Vector of indexes. As many elements as @c grid rows. Each element is the index of a grid column.
        sig_j;
        %> Significance level. Maybe the granularity of this will change (doubt it).
        sig_threshold = -log10(0.05);
        %> Vector of indexes. As many elements as @c grid rows. Each element is the index of a grid column.
        rowname_j;
        %> ='dataset'. May be @c 'dataset' or 'block'
        rowname_type = 'dataset';
        %> ='dataset'. May be @c 'dataset' or 'block'
        colname_type = 'block';
        %> Used to draw the hint spectrum
        data_hint;
        %> =3.5 Width for lineas and markers. Note that this number will be actually multiplied by the global SCALE.
        linewidth = 3.5;
        %> =0. Whether or not to train the blocks
        flag_train = 0;
    end;
    
    properties(SetAccess=protected)
%         %> Dimensions (number of datasets) X (number of blocks)
%         trainedblocks;
        %> Row-wise information.
        rowdata;
        %> Column-wise information.
        coldata;
        %> Whether the x-axis is reverse or not
        flag_reverse = 0;
    end;
    

    properties(SetAccess=protected)
        flag_booted = 0;
        flag_data = 0;
    end;
    
    methods
        function o = bmtable()
%             o.classtitle = 'BMTable';
%             o.flag_ui = 0; % Not published in GUI
        end;
        
        function o = check_booted(o)
            if ~o.flag_booted
                o = o.boot();
            end;
        end;
        
        function o = boot(o)
            o.flag_data = ~isempty(o.datasets);
            o = o.shake_grid();
            o = o.calc_cols();
        end;
        
        %-------------------------------------------------------------------------------------------------------------------------------
        
        %> Draws all the grades curves from one row of the grid
        %>
        %> This function draws the grades for each item of one given row of the @ref bmtable::grid. Each grade is drawn separately, creating
        %> a multi-panel figure; however, it does not use sub-plots; instead, it draws the whole figure from scratch in one single box-less
        %> plot area.
        function o = draw_lines(o, i_row)
            o = o.check_booted();
            
            nj = size(o.grid, 2);
            flag_sig = ~isempty(o.sig_j) && length(o.sig_j) >= i_row && o.sig_j(i_row) > 0;

            stuff = struct('ytick', [], 'yticklabel', {}, 'hh', [], 'legends', {});
            stuff(1).ytick = [];

            % Determines x-extremities among all x-axes among all blocks in case
            wn1 = Inf;
            wn2 = -Inf;
            for j = 1:nj
                wn1 = min(wn1, min(o.grid{i_row, j}.x));
                wn2 = max(wn2, max(o.grid{i_row, j}.x));
            end;

            cnt = 1;
            hhfrank = [];
            for j = 1:nj
                cel = o.grid{i_row, j};
                yformat = o.units{cel.i_unit}.yformat;
                dl = o.coldata(j);
                y1 = cy(dl.maxy, dl);
                y2 = cy(dl.miny, dl);

                stuff.ytick(end+1) = y1;
                stuff.yticklabel{end+1} = sprintf(yformat, dl.maxy);

                % Significance hachure for current box
                if flag_sig
                    o.draw_significance(o.grid{i_row, o.sig_j(i_row)}, cy([dl.maxy, dl.miny], dl));
                end;
        
                % The grades curve itself
                stuff = o.draw_line(i_row, j, stuff);

                % Significance threshold line
                if flag_sig && o.sig_j(i_row) == j % I.e., the curve that gives the significance level is the very one just drawn.
                    draw_threshold_line([wn1, wn2], cy(o.sig_threshold, dl)); %, [1, 1, 1]*.3);
                end;

                box;
                %Per-curve box
                plot([wn1, wn2, wn2, wn1, wn1], [y1, y1, y2, y2, y1], '-', 'Color', [1, 1 1]*0, 'LineWidth', scaled(2));
                hold on;
                % ???????????????????
%                 plot([wn1, wn2], [1, 1]*y2, '-', 'Color', [1, 1 .1]*0, 'Linewidth', 2);
                if cnt < nj
                    % plot([wn1, wn2], [1, 1]*dl.axisylim(1), '-k', 'LineWidth', 2);
                end;

                cnt = cnt+1;

                stuff.ytick(end+1) = y2;
                stuff.yticklabel{end+1} = sprintf(yformat, dl.miny);        
            end;



            % Fabricates the x ticks
            xtick = floor(max(wn1, wn2)/100)*100:-100:ceil(min(wn1, wn2)/100)*100;
            for i = 1:length(xtick);
                if xtick(i)/200 == floor(xtick(i)/200)
                    hhfrank(end+1) = text(xtick(i), -.05, format_number(xtick(i)), 'HorizontalAlignment', 'center');
                end;
                for j = 1:nj
                    dl = o.coldata(j);
                    ymin = cy(dl.miny, dl);
                    ymax = cy(dl.maxy, dl);
                    EHEH_NEGO = .015;
                    plot([1, 1]*xtick(i), ymin+[0, EHEH_NEGO], 'k', 'LineWidth', scaled(2));
                    plot([1, 1]*xtick(i), ymax+[0, -EHEH_NEGO], 'k', 'LineWidth', scaled(2));
                end;
            end;


            
            % Now fabricates the y ticks
            xtext = iif(o.flag_reverse, wn2+scaled(3), wn1-scaled(3));
            for i = 1:length(stuff.ytick)
                hhfrank(end+1) = text(xtext, stuff.ytick(i), stuff.yticklabel{i}, 'HorizontalAlignment', 'right');
            end;



            %---------------
            set(gca, 'YLim', [-0.005, 1.005]);
            set(gca, 'XLim', [min(wn1, wn2)-1, max(wn1, wn2)+1]);
            if o.flag_reverse
                set(gca, 'XDir', 'reverse');
            end;
            legend(stuff.hh, stuff.legends);
            format_frank(gcf, scaled(1), hhfrank);
            axis off;
            set(gcf, 'Color', [1, 1, 1]);
        end;
        
        
       

        
        %-------------------------------------------------------------------------------------------------------------------------------
        
        %> Draws the Peak Locations (PL) plot
        function o = draw_pl(o, flag_wntext, flag_sig)
            o = o.check_booted();

            global SCALE;
            if ~exist('flag_wntext', 'var')
                flag_wntext = 0;
            end;

            if ~exist('flag_sig', 'var')
                flag_sig = 0;
            end;

            MARKER_MAXSIZE = 17*SCALE;
            MARKER_MINSIZE = 8;

            [ni, nj] = size(o.grid);

            % Determines x-extremities among all x-axes among all blocks
            wn1 = Inf;
            wn2 = -Inf;
            for i = 1:ni
                for j = 1:nj
                    wn1 = min(wn1, min(o.grid{i, j}.x));
                    wn2 = max(wn2, max(o.grid{i, j}.x));
                end;
            end;


            hh = [];
            hout = [];

            xlim = [floor(round(wn1/50)*50/100)*100, ceil(round(wn2/50)*50/100)*100];


            ll = struct.empty;
            

            % % Significance indication
            % if flag_sig
            %     for i_dataset = 1:ni
            %         height = i_dataset;
            % 
            %         item = o.items{i_dataset};
            % 
            %     
            %         for i = 1:length(item.bmresults)
            %             if strcmp(item.bmresults{i}.prefix, 'bmresult_p')
            %                 bm_significance = item.bmresults{i};
            %                 break;
            %             end;
            %         end;
            %         
            %         bmresult_draw_significance(bm_significance, o, [height+.45, height-.45]);
            %     end;
            % end;
            
            if ~isempty(o.data_hint)
                hint = mean(o.data_hint.X, 1);
                hint = -hint/max(hint)*.5*ni+ni+1;
                draw_hint_curve(o.data_hint.fea_x, hint);
                hold on;
            end;


            % Draw the vertical lines which will help identify the wavenumbers
            if 1
                for x = ceil(wn1/50)*50:50:floor(wn2/50)*50

                    % vertical bmresult cannot overlap the "natural" matlab tick
                    if x/200 == floor(x/200)
                        uf = 0.17/8*ni;
                    else
                        uf = 0.02/8*ni;
                    end;

                    plot([x, x], [uf, ni+1-uf], '--', 'LineWidth', 1.5*SCALE, 'Color', .5*[1, 1, 1]);
                    hold on;
                end;
            end;

            
            FLAG_ONEMARKERSCALE = 0;
            
            if FLAG_ONEMARKERSCALE
                miny = Inf;
                maxy = -Inf;
                for i = 1:ni
                    for j = 1:nj
                        cel = o.grid{i, j};
                        ycalc = abs(cel.y(cel.peakidxs));
                        miny = min([ycalc(:)', miny]);
                        maxy = max([ycalc(:)', maxy]);
                    end;
                end;
            end;
            
            
            % Calculates x for "rowname"
            xspan = abs(wn2-wn1);
            xspc = xspan*0.02;
            xtext = iif(o.flag_reverse, wn2+xspc, wn1-xspc);

            for i = 1:ni
                height = i;
                
                % Significance hachure for current line
                flag_sig = ~isempty(o.sig_j) && length(o.sig_j) >= i && o.sig_j(i) > 0;
                if flag_sig
                    o.draw_significance(o.grid{i, o.sig_j(i)}, [height+.45, height-.45]);
                end;
                
                plot(xlim, height*[1, 1], 'k', 'LineWidth', scaled(3)); % Horizontal line
                hold on;
                
                % "Row name"
                hh(end+1) = text(xtext, height, o.get_rowname(i), 'HorizontalAlignment', 'right');
            end;

            
            % Makes box before the markers so that the markers appear on top
            set(gca, 'XTick', ceil(wn1/100)*100:200:ceil(wn2/100)*100);
            set(gca, 'XLim', [min(wn1, wn2)-1, max(wn1, wn2)+1]);
            % set(gca, 'XGrid', 'on');
            % set(gca, 'XMinorGrid', 'on');
            % set(gca, 'XMinorTick', 'on');
            set(gca, 'YTick', []); %1:ni);
            % set(gca, 'YTickLabel', []);
            set(gca, 'YLim', [0, ni+1]);
            if o.flag_reverse
                set(gca, 'XDir', 'reverse');
            end;
            set(gca, 'YDir', 'reverse');
            make_box();

            
            for i = 1:ni
                height = i;
                
                for j = 1:nj
                    ll = o.add_legend(i, j, ll);
                    cel = o.grid{i, j};
                    art = o.arts{cel.i_art};
                    y = cel.y(cel.peakidxs);
                    ycalc = abs(y);
                    if sum(y == Inf) == numel(y)
                        ycalc(y == Inf) = 0;
                    else
                        ycalc(y == Inf) = max(y(y ~= Inf));
                    end;
                    x = cel.x(cel.peakidxs);
                    no_markers = length(x);

                    if max(ycalc) ~= min(ycalc)
                        if ~FLAG_ONEMARKERSCALE
                            miny = min(ycalc);
                            maxy = max(ycalc);
                        end;
                        markersizes = (ycalc-miny)/(maxy-miny)*(MARKER_MAXSIZE-MARKER_MINSIZE)+MARKER_MINSIZE;
                    else
                        markersizes = ones(1, no_markers)*MARKER_MAXSIZE;
                    end;

                    for i_marker = 1:no_markers
                        % Plots the markers
                        htemp = plot(x(i_marker), height, 'LineStyle', 'none', 'Marker', art.marker, 'Color', art.color, ...
                            'MarkerSize', markersizes(i_marker)*art.markerscale, 'LineWidth', o.linewidth*SCALE); %, 'MarkerFaceColor', 'w');
                        if flag_wntext
                            text(x(i_marker), height-.1, sprintf('%4.0f', x(i_marker)));
                        end;
                    end;
                end;        
            end;

            o.make_legend(ll);
            format_frank(gcf, scaled(1), hh);
            resize_legend_markers(15);
        end;
    end;            
    
    


    %=================================================================================================================================
    
    
    

    % Lower-level stuff
    methods(Access=protected)
        %> Draws a line an updates 'stuff' structure. This structure contains yticks, yticklabels,
        %> handles for legends and legend texts
        function stuff = draw_line(o, i, j, stuff)
            global SCALE;
            cel = o.grid{i, j};
            dl = o.coldata(j);
            art = o.arts{cel.i_art};
            
            ypeaks = protect_against_inf(cel.y);
            
            
            % Draws the curve <----------------------------
            if ~o.units{cel.i_unit}.flag_hist
                % htemp will be used for legend if there is no peak idx
                htemp = plot(cel.x, cy(cel.y, dl), 'Color', art.color, 'LineWidth', o.linewidth*SCALE);
            else
                htemp = stem(cel.x, cy(cel.y, dl), 'Color', art.color, 'LineWidth', o.linewidth*SCALE*1.5, 'Marker', 'none', 'BaseValue', cy(0, dl));
            end;
            hold on;

            % Zero line
            if o.units{cel.i_unit}.flag_zeroline
                plot([cel.x(1), cel.x(end)], [1, 1]*cy(0, dl), 'Color', art.color, 'LineWidth', o.linewidth*SCALE);
                stuff.ytick(end+1) = cy(0, dl);
                stuff.yticklabel{end+1} = '0';        
            end;
            
            % Legend: tries to use marker as symbol, otherwise the line
            if ~isempty(cel.peakidxs)
                stuff.hh(end+1) = plot(cel.x(cel.peakidxs), cy(ypeaks(cel.peakidxs), dl), ...
                    'Color', art.color, 'Marker', art.marker, 'LineWidth', o.linewidth*SCALE, 'MarkerSize', 15*sqrt(SCALE), 'LineStyle', 'none' ...
                   );
            else
                stuff.hh(end+1) = htemp;
                
            end;
            if strcmp(o.colname_type, 'dataset')
                if isempty(o.datasets)
                    irerror('Wants to take legend from dataset, but datasets property is empty!');
                end;
                stuff.legends{end+1} = o.datasets(cel.i_dataset).title;
            elseif strcmp(o.colname_type, 'block')
                stuff.legends{end+1} = o.get_gradeslegend(cel);
            end;
        end;
        

        
        function o = draw_significance(o, cel, yy)
            y1 = yy(1);
            y2 = yy(2);
            flagg = cel.y >= o.sig_threshold;

            spc = abs(cel.x(2)-cel.x(1));
            
            % Non-significant intervals will ba hatched
            flag_in = 0; % Inside a non-significant
            for i = 1:length(flagg)+1
                if flag_in && (i > length(flagg) || flagg(i))
                    flag_in = 0;
                    draw_hachure([cel.x(i-1)-spc/4, y2, abs(cel.x(mark)-cel.x(i-1))+spc/2, y1-y2]);
                    hold on;
                elseif ~flag_in && i <= length(flagg) && ~flagg(i)
                    flag_in = 1;
                    mark = i;
                end;
            end;

            hold on;
        end;

        
        %> Empowers grid with calculated fields
        %>
        %> <h3>grid.params</h3>
        %> Grid cell parameters have defaults "idx_fea"=1 and "flag_abs"=1
        function o = shake_grid(o)
            
            [ni, nj] = size(o.grid);
            for i = 1:ni
                for j = 1:nj
                    cel = o.grid{i, j};

                    if ~isempty(cel.params)
                        cel.params = setbatch(struct(), cel.params); % Converts {name, value, ...} into proper fields
                        
                        if ~isfield(cel.params, 'idx_fea')
                            cel.params.idx_fea = 1;
                        end;
                        if ~isfield(cel.params, 'flag_abs')
                            cel.params.flag_abs = 1;
                        end;
                    end;
                    
                    cel.block = o.get_initialblock(cel);
                    if o.flag_data && o.flag_train
                        cel.block = cel.block.boot();
                        cel.block = cel.block.train(o.datasets(cel.i_dataset));
                    end;
                    
                    cel.y = o.get_grades(cel);
                    cel.x = o.get_grades_x(cel);
                    if cel.i_peakdetector > 0 && numel(o.peakdetectors) > 0
                        pd = o.peakdetectors{cel.i_peakdetector};
                        pd = pd.boot(cel.x, cel.y);
                        cel.peakidxs = pd.use([], cel.y);
                    else
                        cel.peakidxs = [];
                    end;
                    o.grid{i, j} = cel;
                    
                    if i == 1 && j == 1
                        o.flag_reverse = cel.x(1) > cel.x(end);
                    end;
                end;
            end;
        end;
        
        
        
        %> Calculations before draw_lines()
        %>
        %> First pass finds minima and maxima for each column across all rows. This will ensure that all draw_lines() (using one row only)
        %> will nevertheless use y-scales that will be the same for any row wich which draw_lines() is called.
        %>
        %> Second pass will transfer the minima and maxima to absolute graphical coordinates, as I am not using subplots, but drawing the
        %> figure from scratch instead
        function o = calc_cols(o)
            [ni, nj] = size(o.grid);
            
            % First pass: Searches for maximum and minimum over all row cases of method j
            for j = 1:nj
                maxy = -Inf;
                miny = Inf;
                for i = 1:ni
                    ytemp = protect_against_inf(o.grid{i, j}.y);
%                     ytemp(ytemp == Inf) = 0; % This intervention prevents log(0) from flattening some scale

                    maxy = max(maxy, max(ytemp));
                    miny = min(miny, min(ytemp));
                    
                    if o.units{o.grid{i, j}.i_unit}.flag_zeroline || o.units{o.grid{i, j}.i_unit}.flag_zero
                        miny = min(miny, 0);
                        maxy = max(maxy, 0);
                    end;
                end;


                o.coldata(j).maxy = maxy;
                o.coldata(j).miny = miny;
            end;


            FRAMEPERC = .85;
            spacing = (1-FRAMEPERC)/(nj-1);
            height = FRAMEPERC/nj;

            % Second pass: calculates absolute y limits, offsets and scales
            ypos = 0;
            for j = nj:-1:1
                o.coldata(j).scale = 1/(o.coldata(j).maxy-o.coldata(j).miny)*FRAMEPERC/nj;
                o.coldata(j).offset = ypos;

                if j == nj
                    a1 = 0;
                else
                    a1 = spacing/2;
                end;
                if j == 1
                    a2 = 0;
                else
                    a2 = spacing/2;
                end;
                o.coldata(j).axisylim = [ypos-a1, ypos+height+a2];

                ypos = ypos+height+spacing;
            end;
        end;
        
        %> Makes legends: plots the markers then calls the legend() function passing the appropriate handles to it.
        %>
        %> Currently used only by the PL plot. draw_lines() does not use it
        function o = make_legend(o, ll)
            global SCALE;
            n = numel(ll);
            ss = cell(1, n); % strings
            hh = zeros(1, n); % handles
            for i = 1:n
                cel = o.grid{ll(i).i, ll(i).j};
                art = o.arts{cel.i_art};
                % plots somewhere out of the plot area, just to give the handle to legend()
                hh(i) = plot(0, 10, 'Marker', art.marker, 'Color', art.color, 'MarkerSize', 10, 'LineWidth', o.linewidth*SCALE, 'LineStyle', 'none');
                

                if strcmp(o.colname_type, 'dataset')
                    ss{i} = o.datasets(cel.i_dataset).title;
                elseif strcmp(o.colname_type, 'block')
                    ss{i} = o.get_gradeslegend(cel);
                end;
            end;
            legend(hh, ss);
        end;

        
        %> Checks if new (block, params) case is found; if not, adds case
        function ll = add_legend(o, i, j, ll)
            cel = o.grid{i, j};
            flag_found = 0;
            if numel(ll) > 0
                idxs = find([ll.i_block] == cel.i_block);
                for idx = idxs
                    if compare(cel.params, ll(idx).params)
                        flag_found = 1;
                        break;
                    end;
                end;
            end;
            if ~flag_found
                ll(end+1).i_block = cel.i_block;
                ll(end).params = cel.params;
                ll(end).i = i;
                ll(end).j = j;
            end;
        end;

        
        function z = get_rowname(o, i)
            if ~isempty(o.rowname_j)
                j = o.rowname_j(i);
            else
                j = 1;
            end;
            cel = o.grid{i, j};
            z = 'Undefined';
            switch o.rowname_type
                case 'dataset'
                    z = o.datasets(cel.i_dataset).title;
                case 'block'
                    z = o.get_gradeslegend(cel);
            end;
        end;
        
        function blk = get_initialblock(o, cel)
            blk = o.blocks{cel.i_block};
        end;
        
        %> 
        %>
        %> <h3>fcon_linear</h3>
        %> Sensitive to "idx_fea"=1 and "flag_abs"=1 in @c params
        function g = get_grades(o, cel)
            blk = cel.block;
            params = cel.params;
            
            if isa(blk, 'fcon_linear') || isa(blk, 'block_cascade_base')
                g = blk.L(:, params.idx_fea)';
                if params.flag_abs
                    g = abs(g);
                end;
            elseif isa(blk, 'fsel')
                if ~isempty(blk.grades)
                    g = blk.grades;
                else
                    g = zeros(1, numel(blk.grades_x));
                    g(blk.v) = 1;
                end;
            end;
        end;


        function x = get_grades_x(o, cel)
            blk = cel.block;
%             params = cel.params;
            
            if isa(blk, 'fcon_linear') || isa(blk, 'block_cascade_base')
                x = blk.L_fea_x;
            elseif isa(blk, 'fsel')
                x = blk.fea_x;
            else
                irerror(sprintf('Cannot get grades x for object of class "%s"', class(blk)));
            end;
        end;
        
        %> @brief Grades legend for cell
        %>
        %> Backwards, calls of get_L_fea_names(), then sequence of get_description calls
        %>
        %> others: makes default with idx_fea and flag_abs
        function s = get_gradeslegend(o, cel)
            blk = cel.block;
            params = cel.params;

            s = blk.get_description();
            if isa(blk, 'block_cascade_base') || isa(blk, 'fcon_linear')
                names = blk.get_L_fea_names(params.idx_fea);
                s = cat(2, s, ' ', names{1});
            end;
        end;
    end;
end
