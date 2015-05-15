%> architecture optimization for the lasso classifier
classdef goer_clarchsel__lasso < goer_1i
    methods
        function o = setup(o)
            o.classname = 'clarchsel_lasso';
        end;

        function d = customize_session(o, d)
            % Make your experiments here
            % It is possible to do experiments here
%             d.nfs = [4, 7, 10];
        end;
    end;
end
