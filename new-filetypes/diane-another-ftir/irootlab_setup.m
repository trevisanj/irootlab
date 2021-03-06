%      V V
%  vvvO8 8Ovvv
% IRootLab setup generated at 21-Jul-2017 19:04:09.
% Please note that this file may be automatically re-generated by IRootLab.
% Do not add comments, as these will not be kept.
verbose_assert();
db_assert();
fig_assert();
path_assert();
more_assert();

global COLORS COLORS_STACKEDHIST DB FONT FONTSIZE LINESTYLES MARKERS MARKERSIZES MORE PATH SCALE VERBOSE;
SCALE = 1;
COLORS = {[228 26 28]; [55 126 184]; [77 175 74]; [152 78 163]; [255 127 0]; [255 255 51]; [166 86 40]; [247 129 191]; [153 153 153]};
MARKERS = 'so^dvp<h>';
MARKERSIZES = [6 6 6 6 6 6 6 6 6];
FONT = 'Arial';
FONTSIZE = 20;
LINESTYLES = {'-', '--', '-.'};
VERBOSE.minlevel = 0;
VERBOSE.flag_file = 0;
DB.host = 'bioph.lancs.ac.uk';
DB.name = 'cells';
DB.user = 'cells_user';
DB.pass = 'meogrrk';
PATH.data_load = '.';
PATH.data_save = '.';
PATH.data_spectra = '.';
PATH.doc = 'http://trevisanj.github.io/irootlab/doxy';
MORE.pd_maxpeaks = 6;
MORE.pd_mindist_units = 31;
MORE.pd_minheight = 0.1;
MORE.pd_minaltitude = 0.105;
MORE.ssp_stabilitythreshold = 0.05;
MORE.ssp_minhits_perc = 0.031;
MORE.ssp_nf4gradesmode = 'fixed';
MORE.bc_halfheight = 45;
MORE.flag_postpr_grag = 0;
COLORS_STACKEDHIST = {[208 0 0]; [255 51 0]; [241 145 0]; [225 225 0]; [129 215 86]; [43 215 172]; [0 180 225]; [0 96 241]; [0 0 255]; [0 0 156]};
