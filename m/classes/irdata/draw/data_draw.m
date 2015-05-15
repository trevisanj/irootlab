%>@ingroup datasettools
%>@file
%>@brief Draws "all curves in dataset"
%
%> @param data Datast
%> @param flag_pieces=0 Whether to use plot_curve_pieces
%> @param flag_color_per_row=0 If 0, will use one color inside the COLORS global per class.
%>                             If 1, will use one color inside the COLORS global per data row
function data = data_draw(data, flag_pieces, flag_color_per_row)
if nargin < 2 || isempty(flag_pieces)
    flag_pieces = 0;
end;
if nargin < 3 || isempty(flag_color_per_row)
    flag_color_per_row = 0;
end;

if flag_pieces
    f_plot = @plot_curve_pieces;
else
    f_plot = @plot;
end;

pieces = data_split_classes(data);
h = [];
llabels = {};
for i = 1:length(pieces)
    if pieces(i).no > 0
        %eh = zeros(1, size(pieces(i).X, 2));
        
        args = {'LineWidth', scaled(1)};
        if ~flag_color_per_row
            args = [args, 'Color', find_color(i)];
        end;
        h_temp = f_plot(data.fea_x, pieces(i).X', args{:});
        if iscell(h_temp)
            h_temp = cell2mat(h_temp); % plot_curve_pieces returns a cell, which it shouldn't. However, it is too late to change this, for compatibility.
        end;
        h(end+1) = h_temp(1);
        llabels{end+1} = data.classlabels{i};
        hold on;
    end;
end;
legend(h, llabels);

alpha(0);

format_xaxis(data);
format_yaxis(data);
format_ylim(data);
format_frank();
