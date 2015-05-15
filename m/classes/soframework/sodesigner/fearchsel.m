%> FEARCHSEL - Feature Extraction Design
%>
%> This class gives a chance to customize anything from the default objects, apart from allowing for a sostage_cl starting point
%>
%>
classdef fearchsel < sodesigner
    methods
        function o = fearchsel()
            o.chooser = o.oo.fearchsel_chooser;
        end;
    end;
end
