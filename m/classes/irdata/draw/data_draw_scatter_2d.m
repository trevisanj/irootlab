%>@ingroup datasettools
%>@file
%>@brief Draws 2-D scatter plot

%> @param data dataset
%> @param idx_fea What features to use. Numbers point to columns in @c data.X
%> @param confidences a list of percentages (]0, 1[) for the confidence ellipses
%> @param textmode=0
%>   @arg 0 - no text anotation
%>   @arg 1 - annotates "obsnames"
%>   @arg 2 - annotates "groupcodes"
function data_draw_scatter_2d(data, idx_fea, confidences, textmode)
if ~exist('confidences', 'var')
    confidences = [];
end;
if ~exist('textmode', 'var')
    textmode = 0;
end;

if any(idx_fea > data.nf)
    irerror(sprintf('Dataset has only %d feature(s)!', data.nf));
end;

mins = min(data.X(:, idx_fea), [], 1);
maxs = max(data.X(:, idx_fea), [], 1);
lens = maxs-mins;

pieces = data_split_classes(data);
no_classes = size(pieces, 2);
no_fea = length(idx_fea);

i_count = 1;
for ix = 1:no_fea-1
    for iy = ix+1:no_fea
        if no_fea > 2
            subplot(no_fea-1, no_fea-1, (iy-2)*(no_fea-1)+ix);
        end;

        ihandle = 1;
        for i = 1:no_classes
            X = pieces(i).X(:, idx_fea([ix iy]));

            hh = plot(X(:, 1), X(:, 2), 'Color', find_color(i), 'Marker', find_marker(i), 'MarkerFaceColor', find_color(i), 'LineStyle', 'none', 'MarkerSize', find_marker_size(i));
            if ~isempty(hh)
                handles(ihandle) = hh(1);
                ihandle = ihandle+1;
            end;
            hold on;
            
            
            if textmode == 1 && ~isempty(pieces(i).obsnames)
                text(X(:, 1), X(:, 2), pieces(i).obsnames); %, 'FontName', FONT, 'FontSize', FONTSIZE*.7);
            elseif textmode == 2 && ~isempty(pieces(i).groupcodes)
                text(X(:, 1), X(:, 2), pieces(i).groupcodes);
            end;

            % ellipses
            if ~isempty(confidences)
                m = mean(X);
                C = cov(X);
                for j = 1:length(confidences)
                    error_ellipse(C, m, 'conf', confidences(j), 'Color', find_color(i), 'LineWidth', scaled(2));
                end;
            end;
        end
        
        feanames = data.get_fea_names([idx_fea(ix) idx_fea(iy)]);
        if iy == ix+1
            title(feanames{1});
        end;
        if ix == 1
            ylabel(feanames{2});
        end;
        if i_count == 1
            l = legend(handles, data_get_legend(data));
            if is_2014()  % Working around changes in R2014a
                prop = 'Position';
            else
                prop = 'OuterPosition';
            end;
                
            carmelia = get(l, prop);
            wi = carmelia(3);
            he = carmelia(4);
            set(legend, prop, [.9, .9, 0, 0]+[-wi, -he, wi, he]);
        end;
        if iy < no_fea % || 1
            set(gca, 'XTick', []);
        end;
        if ix > 1 % || 1
            set(gca, 'YTick', []);
        end;
        format_frank();
        K = 0.05;
        xlim([mins(ix)-lens(ix)*K, maxs(ix)+lens(ix)*K]);
        ylim([mins(iy)-lens(iy)*K, maxs(iy)+lens(iy)*K]);      
        
        i_count = i_count+1;
    end;
end;
