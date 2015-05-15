%> @ingroup misc maths
%> @brief in-line "IF"
%> @file
%>
%> This function takes three parameters. The first parameter is a condition. If the condition is true,
%> returns the second argument, otherwise the third.
%>
%> @param condition
%> @param out1
%> @param out2
%> @return out
function out = iif(cond, x1, x2)
if cond
    out = x1;
else
    out = x2;
end;
