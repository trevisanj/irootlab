%>@ingroup graphicsapi globals idata assert
%>@file
%>@brief Initializes globals COLORS, FONT, MARKERS, etc, if not present.
%>
%> Please check the source code for reference on variables and default values.
function fig_assert()
global COLORS MARKERS MARKERSIZES FONT FONTSIZE LINESTYLES SCALE COLORS_STACKEDHIST;

if isempty(SCALE)
    %Multiplier for MARKERSIZES, FONTSIZE, line widths etc
    SCALE = 1;
end;

if isempty(COLORS)
    % Sequence of colors for general purpose
    a = [...
        228, 26, 28; ...
        55, 126, 184; ...
        77, 175, 74; ...
        152, 78, 163; ...
        255, 127, 0; ...
        255, 255, 51; ...
        166, 86, 40; ...
        247, 129, 191; ...
        153, 153, 153; ...
        ];
    a = round(a/255*1000)/1000;
    COLORS = mat2cell(a, ones(1, size(a, 1)), 3);
end;

if isempty(LINESTYLES)
    % Sequence of line styles
    LINESTYLES = {'-', '--', '-.'};
end;
if isempty(MARKERS)
    % Sequence of markers for scatterplots etc.
    MARKERS = 'so^dvp<h>';
    % Sequence of marker sizes. Must match @c MARKERS in number of elements.
    MARKERSIZES = 2*[3 3 3 3 3 3 3 3 3];
end;
if isempty(FONT)
    % Font for figure axis labels, legend, title etc.
    FONT = 'Arial';
end;
if isempty(FONTSIZE)
    % Font size for figure axis labels, legend, title etc.
    %
    % FONTSIZE = 40; % Becomes aprox. 16.5 when a 300dpi PNG is exported and made 18cm wide in Word. 
    %                % PS: I think it goes well on my 1650x... monitor but a different screen size would need another FONTSIZE
    %                % to achieve the same effect (i.e. font size of 16.5 in Word)
    %                % This is good provision for potential reduction when the figure goes to the paper
    FONTSIZE = 20;
end;
if isempty(COLORS_STACKEDHIST)
    % Colors for draw_stacked() (stacked feature histogram)
    COLORS_STACKEDHIST = make_colors_stackedhist();
end;


%---------------------------------
function c = make_colors_stackedhist()
% This is the colormap that was used for the stacked histograms

cm = jet(20);
cm = cm(19:-2:1, :);
f = (cos(linspace(0, 2*pi, 10))*.1+1)';
cm = bsxfun(@times, cm, f);
cm = cm/max(cm(:));
cm = round(cm*1000)/1000;

c = mat2cell(cm, ones(1, 10), 3);
