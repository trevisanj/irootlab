%> Chooser that does not use time
%>
%> Determines the best compromise between accuracy and times
%>
%>
classdef chooser_notime < chooser_base
    methods
        %> Both @c ratess and @c timess are [k]x[number of cases] matrices
        %> @param ratess
        %> @param timess Ignored in this class
        function idx = do_use(o, ratess, timess) %#ok<*MANU,*INUSD>
            rates = mean(ratess, 1);
            [val, idx] = max(rates); %#ok<*ASGLU>
        end;       
    end;
end
