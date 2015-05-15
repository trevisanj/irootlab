%> Here, the sovalues object within is requested to decide.
%>
%> This soitem will be typically an input to a "merge" task (not foldmerge)
classdef soitem_diachoice < soitem_sovalues
    methods(Sealed)
        %> Retrieves a sostage from the sovalues to replace in the diagnosissystem
        function dia_out = get_modifieddia(o)
            v = o.sovalues.choose_one();
            dia_out = v.dia;
        end;
    end;        
end
