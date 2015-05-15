%> @ingroup globals codegen
%> @file
%> @brief Evaluates code in 'base' workspace, adds to IRCODE.s and to the IRootLab log editbox if open
%>
%> @param s code
%> @param title if provided, will be added before the code as comment
function ircode_eval(s, title)
ircode_assert();

if exist('title', 'var')
    s = ['%' title sprintf('\n') s];
else
    title = '';
end;
% s = [sprintf('\n') s];

    
% Does same thing but without the ircode_assert()
try
    t = tic();
    ircode_eval2(s, title);
    tt = toc(t);
    if tt > 0.5
        ircode_eval2(sprintf('% -- Ellapsed time: %g seconds\n', tt));
    end;
catch ME
%     ircode_eval2(['% -- ERROR at ', datestr(now), 10, 10]);
    rethrow(ME);
end;
    

