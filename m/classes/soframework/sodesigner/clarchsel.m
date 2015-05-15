%> architecture optimization for classifiers
%>
%> This class gives a chance to customize anything from the default objects, apart from allowing for a sostage_cl starting point
%>
%>
classdef clarchsel < sodesigner
    methods
        function o = customize(o)
            o = customize@sodesigner(o);
            o.chooser = o.oo.clarchsel_chooser;
        end;
    end;
end
