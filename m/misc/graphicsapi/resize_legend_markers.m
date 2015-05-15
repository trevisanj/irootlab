%>@ingroup graphicsapi
%>@file
%>@brief Resizes legend markers
%
%> @param size=12 size
%> @param flag_line=0 if 0, resizes 'MarkerSize', else resizes 'LineWidth'
function resize_legend_markers(size, flag_line)

if ~exist('size')
    size = 12;
end;

if ~exist('flag_line')
    flag_line = 0;
end;


h = legend;
if isempty(h)
    irwarning('Figure has no legend!');
else
    h_ = get(h, 'children');
    for i = 1:length(h_)
        hh_ = get(h_(i));
        if strcmp(hh_.Type, 'line')
            if flag_line
                set(h_(i),'LineWidth', size);
            else
                set(h_(i),'MarkerSize', size);
            end;
        end;
    end;
end;
