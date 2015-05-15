%> @ingroup globals codegen
%> @file
%> @brief Same as @ref ircode_eval() but without the assestion and parameter check.
%> @sa ircode_eval.m
%
%> @param s Piece of code
%> @param title Unused at the moment
function ircode_eval2(s, title)
if nargin < 2
    title = [];
end;
flag_add = 1;

try
    evalin('base', s);
catch ME
    disp('Generated code behaved badly');
    disp('----------------------------');
    disp(s);
    rethrow(ME);
end;

if flag_add
    ircode_add(s, title);
end;

