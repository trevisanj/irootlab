% frbm_save_movie(): produces a GIF movie showing the clustering evolution
%
% This function does not boot the classifier
%
% function frbm_save_movie(clssr, pars)
function frbm_save_movie(clssr, pars)

if ~isfield(pars, 'filename')
    irerror('''pars'' must have a ''.filename'' (e.g., xxxx.gif) field!');
end;


figure;
% asd = input('Please resize the figure and press <Enter> ');
maximize_window([], 1.2, 0.7);

global im map i_frame;
clear im map;
global im map i_frame;
i_frame = 1;

clssr.f_after_iteration = @(o) draw_it(o, pars);

clssr = clssr.train(pars.ds_train);

imwrite(im, map, pars.filename, 'DelayTime', .15, 'LoopCount', inf);


%-----------------------------------------------------------------------------------------------------------------------
function draw_it(o, pars)
global im map i_frame;

delete(gca);
o.draw_domain(pars);
set(gcf, 'Color', [1, 1, 1]);


frame = getframe(gcf);

if i_frame == 1
    [im, map] = rgb2ind(frame.cdata, 256, 'nodither');
    im(1, 1, 1, size(pars.ds_train.X, 1)) = 0;
end;
im(:, :, 1, i_frame) = rgb2ind(frame.cdata, map, 'nodither');

i_frame = i_frame+1;
