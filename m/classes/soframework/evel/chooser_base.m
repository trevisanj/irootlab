%> Model chooser - base class
%>
%>
classdef chooser_base
    properties
        ratesname = 'rates';
        timesname = 'times3';
    end;
        
    methods(Abstract)
        %> Both @c ratess and @c timess are [k]x[number of cases] matrices
        %> @param ratess
        %> @param timess
        idx = do_use(o, ratess, timess);
    end;
    
    methods(Sealed)
        function idxs = use(o, values)
            si = size(values);
            v2 = values(:); % column vector
            ratess = permute(sovalues.getYY(v2, o.ratesname), [3, 1, 2]);
            timess = permute(sovalues.getYY(v2, o.timesname), [3, 1, 2]);
            
            idx = o.do_use(ratess, timess);
            
            % base decomposition
            idx = idx-1;
            for i = 1:numel(si)
                idxs{i} = mod(idx, si(i))+1;
                idx = floor(idx/si(i));
            end;
        end;
    end;
end
