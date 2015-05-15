%>@ingroup graphicsapi globals idata
%>@file
%>@brief Clears globals colors, styles, fonts, etc
function fig_reset()
global COLORS MARKERS MARKERSIZES FONT FONTSIZE LINESTYLES SCALE COLORS_STACKEDHIST;

COLORS = [];
MARKERS = [];
MARKERSIZES = [];
FONT = [];
FONTSIZE = [];
LINESTYLES = [];
SCALE = [];
COLORS_STACKEDHIST = [];
