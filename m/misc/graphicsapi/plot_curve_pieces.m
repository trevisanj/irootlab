%>@ingroup graphicsapi
%>@file
%>@brief Plots a curve in pieces if there is a discontinuity in the x-axis 
%>
%> Mimics the plot() function, but does several plots if x does not have the same increment step.
%>
%> If the 'color' option is not passed in varargin, will rotate the colors
%> in the COLORS global
%
%> @param x vector of dimension [1]x[nf]
%> @param y Vector or matrix of dimension [nf]x[no]. The dimensions here
%>          are inverted to keep consistent with the plot() function
%> @param varargin Will be by-passed to MATLAB's <code>plot()</code>
%> @return handles a cell of handles
function h = plot_curve_pieces(x, y, varargin)

x(y == Inf) = [];
y(y == Inf) = [];
x = round(x*100)/100;
x = x(:); % Makes a column vector
sy = size(y);
if any(sy == 1)
    y = y(:); % Makes a column vector
    ny = 1; % number of data rows
else
    ny = sy(2);
end;

flag_rotate_color = 1;
for i = 1:numel(varargin)
    if ischar(varargin{i})
        if strcmp(upper(varargin{i}), 'COLOR')
            flag_rotate_color = 0;
            break;
        end;
    end;
end;

args = varargin;
% modedelta = abs(mode(diff(x)));
% tol = 1.1*abs(modedelta); % distance difference tolerance

no_points = length(x);
no_plots = 0;
for k = 1:ny
    ynow = y(:, k)';
    i = 1;
    while 1
        flag_break = i > no_points;
        flag_plot = 0;
        flag_new_piece = 0;

        if flag_break
            flag_plot = 1;
        else
            if i == 1
                flag_new_piece = 1;
            else
                if i > 2
                    dist = abs(x(i)-x(i-1));
                    tol = abs(x(i-1)-x(i-2));

                    if dist > tol*1.9
                        flag_plot = 1;
                        flag_new_piece = 1;
                    end;
                end;        
            end;
        end;

        if flag_plot
            no_plots = no_plots+1;

            if flag_rotate_color
                args = [varargin, 'Color', find_color(k)];
            else
                args = varargin;
            end;
            if i-piece_start > 1
                h{no_plots} = plot(x(piece_start:i-1), ynow(piece_start:i-1), args{:});
            else
                % 1-point plot
    %             h{no_plots} = plot(x(piece_start:i-1)*[1, 1]+[-modedelta, modedelta]*.3, ynow(piece_start:i-1)*[1, 1], varargin{:});
                h{no_plots} = plot(x(piece_start), ynow(piece_start), varargin{:});
            end;
            hold on;
        end;

        if flag_break
            break;
        end;

        if flag_new_piece
            piece_start = i;
        end;

    %     if i > 1
    %         dist_old = dist;
    %     end;
        i = i+1;
    end;
end;
