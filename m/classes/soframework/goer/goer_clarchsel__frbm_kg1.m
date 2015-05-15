%> architecture optimization for the frbm_kg1 classifier
classdef goer_clarchsel__frbm_kg1 < goer_1i
    methods
        function o = setup(o)
            o.classname = 'clarchsel_frbm_kg1';
        end;

        function d = customize_session(o, d)
            % Make your experiments here
            % It is possible to do experiments here
%              d.nfs = [4, 7, 10];
        end;
    end;
end
