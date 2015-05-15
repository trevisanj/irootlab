%> @file
%> @ingroup graphicsapi
%> @brief Makes current axis gray
%>
%> I didn't implement an axis input parameter because the function also needs the figure handle,
%> so I decided just to go for the current axis and figure.
function make_axis_gray()
color_ = 1.15*[0.8314    0.8157    0.7843];
set(gca, 'color', color_);
set(gcf, 'InvertHardCopy', 'off'); % This is apparently needed to preserve the gray background
set(gcf, 'color', [1, 1, 1]);


    
