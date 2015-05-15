%> @ingroup soframework graphicsapi
%> @file
%> @brief Draw many subplots (subimages) in two rows
%>
%> First row is rates, second is times3, each column is a different nf
%>
%> expected dimensions: (subdsperc, number of features, C1 (e.g. C), C2 (e.g. gamma))
%>
%> This function is not being used a lot; Could be made into a class some time
%>
%> @sa report_soitem::images_2d
%
%> @param r sovalues object
function view_ratetimesubimages(r) %, saveprefix)


oo = sosetup_scene();

R = sovalues.getYY(r.values, 'rates');
T = sovalues.getYY(r.values, 'times3');
[nnf, nc1, nc2, folds] = size(R);

% R = reshape(R(end, :, :, :, :), [nnf, nc1, nc2, folds]);
% T = reshape(T(end, :, :, :, :), [nnf, nc1, nc2, folds]);

meanR = mean(R, 4);
meanT = mean(T, 4);
maxR = max(meanR(:));
minR = min(meanR(:));
maxT = max(meanT(:));
minT = min(meanT(:));


figure;
for ww = 1:nnf
    subplot(2, nnf, ww);

    o = vis_sovalues_drawimage();
    o.clim = [minR, maxR];
    o.dimspec = {[ww 0 0], [1 2]};
    o.valuesfieldname = 'rates';
    o.flag_transpose = 1;
    o.flag_star = 1;
%     o.chooser = oo.chooser_clarchsel1;
    o.use(r);
    
    replace_title();
    if ww == 1
    else
        xlabel('');
        ylabel('');
    end;

    tickdeal();
    
    colorbardeal(ww, nnf, 'rates');

    
    %----------------


    subplot(2, nnf, ww+nnf);

    o = vis_sovalues_drawimage();
    o.clim = [minT, maxT];
    o.dimspec = {[ww 0 0], [1 2]};
    o.valuesfieldname = 'times3';
    o.flag_logtake = 1;
    o.flag_transpose = 1;
    o.flag_star = 1;
    o.use(r);

    title(''); %replace_title();
    
    xlabel('');
    ylabel('');
%     title('');

    tickdeal(); 

    colorbardeal(ww, nnf, 'times3');
%     maximize_window();
%     save_as_png([], [saveprefix, '_times_nf', int2str(ww), '.png']);
%     close();
end;





%--------------------------------------------------------------------------
function replace_title()

st = get(get(gca, 'title'), 'String');
semicolonpos = find(st == ';');
if ~isempty(semicolonpos)
    st = st(semicolonpos+2:end);
    st = strrep(st, 'Number of features: ', 'nf=');
    title(st);
    set(get(gca, 'title'), 'FontWeight', 'bold');
end;



%--------------------------------------------------------------------------
function colorbardeal(ww, nnf, s)
colorbar('off');
p = get(gca, 'Position');
if ww == nnf
    h = colorbar();
    format_frank(gca, [], h);
end;
set(gca, 'Position', [p(1:2)-.05, p(3:4)*1.15]);
% if ww == nnf
%     %writes text at right of colorbar
%     p = get(h, 'Position');
%     
%     global FONT FONTSIZE; %#ok<*TLEV>
%     text('Position', [p(1)+p(3)+0.1, p(2)+p(4)/2, 0], ...
%               'Rotation', -90, ...
%               'HorizontalAlignment', 'center', ...
%               'VerticalAlignment', 'middle', ...
%               'FontName', FONT, ...
%               'FontSize', scaled(FONTSIZE), ...
%               'String', labeldict(s));
% end;


%--------------------------------------------------------------------------
function tickdeal()
tl = get(gca, 'XTickLabel');
tl = cellfun(@(x) iif(str2num(x) == floor(str2num(x)), x, ''), tl, 'UniformOutput', 0); %#ok<*ST2NM>
set(gca, 'XTickLabel', tl);

tl = get(gca, 'YTickLabel');
tl = cellfun(@(x) iif(str2num(x) == floor(str2num(x)), x, ''), tl, 'UniformOutput', 0); %#ok<*ST2NM>
set(gca, 'YTickLabel', tl);
