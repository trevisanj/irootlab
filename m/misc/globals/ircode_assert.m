%> @ingroup globals codegen assert
%> @file
%> @brief Initializes the @c IRCODE global, if not present.
%>
%> For reference on the IRCODE global, please check the source code of this file.
function list = ircode_assert()
global IRCODE;
if isempty(IRCODE) || isempty(IRCODE.s)
    IRCODE.s = {};
    IRCODE.filename = '';
    ircode_eval2('', ['IRoot started @ ' datestr(now)]);
end;
