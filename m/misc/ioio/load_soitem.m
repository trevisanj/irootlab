%>@ingroup ioio misc
%>@file
%>@brief Loads MAT file containing a r structure with a item field
%
%> @param filename File name
function load_soitem(filename)
global TEMP;
try
    clear('r');
    load(filename);
    if exist('r', 'var')
        if isprop(r, 'item') || isfield(r, 'item')
            TEMP = r.item;
            [a, b, c] = fileparts(filename); %#ok<*NASGU,*ASGLU>
            b = b(8:end); % Skips the "soout__"
            s = ['global TEMP; ', good_varname(b), ' = TEMP;'];
            evalin('base', s);
            irverbose(s, 3);
        end;
    end;

catch ME
    irverbose(sprintf('Failed reading file "%s": %s', filename, ME.message), 1);
end;
evalin('base', 'global TEMP; clear TEMP;');