%> Returns a cascade block to perform the default pre-processing Pre-processing
%> @file
%>
%> The sequence is: Cut1800-900->Rubberband->AmideI
%>
function blk = get_defaultpp()

sos = sostage_pp_rubbernorm(); % Note that this does not needs a sodata
sos.sodata = sodata_pp_rubbernorm();
blk = sos.get_block();


