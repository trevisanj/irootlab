%> @ingroup globals codegen
%> @file
%> @brief Adds string to auto-generated code buffer (without executing)
%> @sa ircode_eval.m
%
%> @param s Piece of code
%> @param title Unused at the moment
function ircode_add(s, title)
global handles_irootlab IRCODE;

if ~iscell(IRCODE.s)
    IRCODE.s = {};
    ircode_add(['% ', sprintf('First code sent @ %s.\n', datestr(now))]);
end;

if isempty(IRCODE.filename)
    IRCODE.filename = fullfile(pwd(), find_filename('irr_macro', '', 'm'));
    ircode_add(['% Log filename: ', IRCODE.filename, 10]);
end;

IRCODE.s{end+1} = s;

h = -1;
try
    h = fopen(IRCODE.filename, 'w');
    fwrite(h, sprintf('%s', IRCODE.s{:}));
catch ME15
    fprintf('ERROR trying to save file %s: %s\nLog was not saved.\n', IRCODE.filename, ME15.message);
end;
if h ~= -1
    fclose(h);
end;


try
    if ~isempty(handles_irootlab)
        set(handles_irootlab.editCode, 'String', IRCODE.s);
        set(handles_irootlab.text_codefilename, 'String', ['File ' IRCODE.filename]);
    end;
catch ME2
    %> nevermind
end;


