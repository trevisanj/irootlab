%> Skips the menu and goes straight to reportbuilder.g0()
function build_reports()
scenesetup;
% a.boot();
r = reportbuilder();
r.print_status();
r = r.go();
if r.flag_finished
    disp('Bye :)');
end;
