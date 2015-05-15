%> @ingroup globals codegen
%>@file
%>@brief Opens the running "irr_macro_<nnnn>" in MATLAB editor
function ircode_edit()
ircode_assert();
global IRCODE;
edit(IRCODE.filename);

