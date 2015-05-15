%> architecture optimization for the lsth classifier
classdef goer_clarchsel__lsth < goer_1i
    methods
        function o = setup(o)
            o.classname = 'clarchsel_lsth';
        end;

        function d = customize_session(o, d)
            % Make your experiments here
            % It is possible to do experiments here
%            d.nfs = [7, 8, 10, 20, 30];
        end;
    end;
end
