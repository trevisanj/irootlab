%>@ingroup datasettools
%>@file
%>@brief draw3d2_core
function handles = draw3d2_core(data, idxfea, confidences, flags_min, ks, flag_wallpoints)

[minmax, xyz] = draw3d2_get_minmax(data, idxfea, flags_min, ks);

spans = minmax(2, :)-minmax(1, :);


KOFF = 0.005;

pieces = data_split_classes(data);
no_classes = size(pieces, 2);
for i = 1:no_classes
    X = pieces(i).X(:, idxfea([1 2 3]));
    
    hh = plot3(X(:, 1), X(:, 2), X(:, 3), 'Color', find_color(i), 'Marker', find_marker(i), 'MarkerSize', find_marker_size(i), 'MarkerFaceColor', find_color(i), 'LineStyle', 'none');
    handles(i) = hh(1);
    hold on;

    if flag_wallpoints
        plot3(X(:, 1), X(:, 2), iif(flags_min(3), minmax(1, 3)+spans(3)*KOFF*(i-1), minmax(2, 3)-spans(3)*KOFF*(i-1))*ones(pieces(i).no, 1), 'Color', find_color(i), 'Marker', find_marker(i), 'MarkerSize', find_marker_size(i)*.6, 'MarkerFaceColor', find_color(i), 'LineStyle', 'none', 'MarkerEdgeColor', 'none');
        plot3(X(:, 1), iif(flags_min(2), minmax(1, 2)+spans(2)*KOFF*(i-1), minmax(2, 2)-spans(2)*KOFF*(i-1))*ones(pieces(i).no, 1), X(:, 3), 'Color', find_color(i), 'Marker', find_marker(i), 'MarkerSize', find_marker_size(i)*.6, 'MarkerFaceColor', find_color(i), 'LineStyle', 'none', 'MarkerEdgeColor', 'none');
        plot3(iif(flags_min(1), minmax(1, 1)+spans(1)*KOFF*(i-1), minmax(2, 1)-spans(1)*KOFF*(i-1))*ones(pieces(i).no, 1), X(:, 2), X(:, 3), 'Color', find_color(i), 'Marker', find_marker(i), 'MarkerSize', find_marker_size(i)*.6, 'MarkerFaceColor', find_color(i), 'LineStyle', 'none', 'MarkerEdgeColor', 'none');
    end;
    
    % ellipses
    if ~isempty(confidences)
        m = mean(X);
        C = cov(X);
        for j = 1:length(confidences)
            error_ellipse2(C, m, 'conf', confidences(j), 'style', find_color(i), 'xyz', xyz);
        end;
    end;
end
