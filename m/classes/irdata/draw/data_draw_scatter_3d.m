%>@ingroup datasettools
%>@file
%>@brief Draws 3-D scatter plot

%> @param data dataset
%> @param idx_fea What features to use. Numbers point to columns in @c data.X
%> @param confidences a list of percentages (]0, 1[) for the confidence ellipses
%> @param textmode=0
%>   @arg 0 - no text anotation
%>   @arg 1 - annotates "obsnames"
%>   @arg 2 - annotates "groupcodes"
%> @return <em>[data]</em>
%> @return <em>[data, handles]</em>. handles: handles for the legends
function varargout = data_draw_scatter_3d(data, idx_fea, confidences, textmode)
global FONT FONTSIZE SCALE;


if ~exist('confidences', 'var')
    confidences = [];
end;

if ~exist('textmode', 'var')
    textmode = 0;
end;

if numel(idx_fea) < 3
    irerror('idx_fea must have 3 elements!');
end;
if any(idx_fea > data.nf)
    irerror(sprintf('Dataset has only %d feature(s)!', data.nf));
end;

pieces = data_split_classes(data);

no_classes = size(pieces, 2);
for i = 1:no_classes
    X = pieces(i).X(:, idx_fea([1 2 3]));
    
    hh = plot3(X(:, 1), X(:, 2), X(:, 3), 'Color', find_color(i), 'Marker', find_marker(i), 'MarkerSize', find_marker_size(i), 'MarkerFaceColor', find_color(i), 'LineStyle', 'none');
    handles(i) = hh(1);
    hold on;
    
    if textmode == 1 && ~isempty(pieces(i).obsnames)
        text(X(:, 1), X(:, 2), X(:, 3), pieces(i).obsnames); %, 'FontName', FONT, 'FontSize', FONTSIZE*.7);
    elseif textmode == 2 && ~isempty(pieces(i).groupcodes)
        text(X(:, 1), X(:, 2), X(:, 3), pieces(i).groupcodes); %, 'FontName', FONT, 'FontSize', FONTSIZE*.7);
    end;
    
    
    
    % ellipses
    if ~isempty(confidences)
        m = mean(X);
        C = cov(X);
        for j = 1:length(confidences)
            error_ellipse(C, m, 'conf', confidences(j), 'Color', find_color(i));
        end;
    end;
end

mins = min(data.X(:, idx_fea), [], 1);
maxs = max(data.X(:, idx_fea), [], 1);
lens = maxs-mins;
K = 0.05;
xlim([mins(1)-lens(2)*K, maxs(1)+lens(1)*K]);
ylim([mins(2)-lens(2)*K, maxs(2)+lens(2)*K]);      
zlim([mins(3)-lens(3)*K, maxs(3)+lens(3)*K]);      


feanames = data.get_fea_names(idx_fea);
xlabel(feanames{1});
ylabel(feanames{2});
zlabel(feanames{3});

hleg = legend(handles, data_get_legend(data));
format_frank();

if nargout <= 1
    varargout = {data};
elseif nargout == 2
    varargout = {data, handles};
end;
