function open_demo(s)
try
    evalin('base', 'setup_load'); % To clean space and restore globals that may be messed up by analysis
    evalin('base', s);
catch ME
    irerrordlg(sprintf('Failed runnind demo %s: %s.\nCheck MATLAB command window for more information about the error.', s, ME.message), 'Sorry');
    rethrow(ME);
end;