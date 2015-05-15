%> architecture optimization for the frbm_ori classifier
classdef goer_clarchsel__frbm_ori < goer_1i
    methods
        function o = setup(o)
            o.classname = 'clarchsel_frbm_ori';
        end;

        function d = customize_session(o, d)
            % Make your experiments here
            % It is possible to do experiments here
%               d.nfs = [4];
        end;
    end;
end
