%> architecture optimization for the ann classifier
classdef goer_clarchsel__ann < goer_1i
    methods
        function o = setup(o)
            o.classname = 'clarchsel_ann';
        end;

        function d = customize_session(o, d)
            % Make your experiments here
            % It is possible to do experiments here
%             d.archs = {[3], [10, 3]};
%             d.nfs = [4, 7, 10];
        end;
    end;
end
