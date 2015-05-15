%>@ingroup graphicsapi
%>@file
%>@brief Makes box around gca using xlim and ylim
function make_box()

v_xlim = get(gca, 'xlim');
v_ylim = get(gca, 'ylim');
% plot(v_xlim([1, 2, 2, 1, 1]), v_ylim([1, 1, 2, 2, 1]), 'LineWidth', scaled(2), 'Color', [0, 0, 0]);

xs = diff(v_xlim);
ys = diff(v_ylim);

p = [v_xlim(1)+xs*.000001, v_ylim(1)+ys*.000001, xs*.999998, ys*.999998];


hh = guidata(gcf);
if isfield(hh, 'boxhandles')
    idx = find(hh.boxaxes == gca());
    if ~isempty(idx)
        h = hh.boxhandles(idx);
        flag_new = 0;
        try
            set(h, 'Position', p, 'LineWidth', scaled(2), 'EdgeColor', [0, 0, 0], 'FaceColor', 'none', 'Clipping', 'off');
        catch ME %#ok<NASGU>
            % Silent exception
            flag_new = 1;
        end;
    else
        flag_new = 1;
    end;
else
    flag_new = 1;
end;

if flag_new
    if ~isfield(hh, 'boxhandles')
        hh.boxaxes = [];
        hh.boxhandles = [];
    end;
    r = rectangle('Position', p, 'LineWidth', scaled(2), 'EdgeColor', [0, 0, 0], 'FaceColor', 'none', 'Clipping', 'off');
    hh.boxaxes(end+1) = gca();
    hh.boxhandles(end+1) = r;
    guidata(gcf, hh);
end;
   
