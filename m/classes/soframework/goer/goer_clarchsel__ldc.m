%> architecture optimization for the ldc classifier
classdef goer_clarchsel__ldc < goer_1i
    methods
        function o = setup(o)
            o.classname = 'clarchsel_ldc';
        end;

        function d = customize_session(o, d)
            % Make your experiments here
            % It is possible to do experiments here
%             d.nfs = [4, 7, 10];
        end;
    end;
end
