%>@file
%>@ingroup guigroup ioio misc graphicsapi interactive
%>@brief Lets the user create a dataset by clicking the mouse and pressing the number keys
colors = 'rbmk';
markers = 'pso<';

figure;
set(gca, 'xlim', [0, 10], 'ylim', [0, 10]);
title('0, 1, 2, 3 for class or E to end');
hold on;

k = 0;
class = 0;
clear classes_ X;
while 1
    [x,y, z] = ginput(1);
    
    if z == 1
        k = k+1;
        X(k, :) = [x, y];
        classes_(k, 1) = class;


        plot(x, y, 'Color', colors(class+1), 'Marker', markers(class+1));
        hold on;
        set(gca, 'xlim', [0, 10], 'ylim', [0, 10]);
    else
        if z >= 48 && z <= 51
            class = z-48;
        elseif z == 'E' || z == 'e'
            disp('Ok');
            break;
        end;
    end;
end;

if k > 1
    data = irdata();
    data.X = X;
    data.classes = classes_;
    data = data.assert_fix();
    f = find_filename('gendata', '', 'txt');
    oio = dataio_txt_basic();
    oio.filename = f;
    oio.save(data);
    disp(['Saved file ' f]);
end;
