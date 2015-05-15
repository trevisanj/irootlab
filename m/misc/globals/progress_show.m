%> @ingroup globals usercomm
%> @file
%> @brief Shows progress bars

function progress_show()
progress_assert();
global PROGRESS;



for ib = 1:numel(PROGRESS.bars)
    bar = PROGRESS.bars(ib);

    ela = toc(bar.tic);
    
    if isempty(bar.perc)
        perccalc = bar.i/(bar.n+realmin);
    else
        perccalc = bar.perc;
    end;
    
    proje = ela/perccalc;
    
    irverbose(['[', ((linspace(0, 1, 25) > perccalc)*3+43), ']', sprintf('%6.0fs/%6.0fs - %6.2f%% %s', ela, ...
        iif(proje < Inf, sprintf('%6.0f', proje), '     ?'), perccalc*100, bar.title)], 3);

end;
