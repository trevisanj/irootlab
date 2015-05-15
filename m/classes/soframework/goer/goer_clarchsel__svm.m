%> architecture optimization for the svm classifier
classdef goer_clarchsel__svm < goer_1i
    methods
        function o = setup(o)
            o.classname = 'clarchsel_svm';
        end;

        function d = customize_session(o, d)
            % Make your experiments here
            % It is possible to do experiments here
%             d.cs = [10, 100, 1000];
%             d.gammas = [.001, .01, .1, 1];
%             d.nfs = [2, 10];
        end;
    end;
end
