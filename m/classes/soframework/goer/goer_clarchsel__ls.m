%> architecture optimization for the ls classifier
classdef goer_clarchsel__ls < goer_1i
    methods
        function o = setup(o)
            o.classname = 'clarchsel_ls';
        end;

        function d = customize_session(o, d)
            % Make your experiments here
            % It is possible to do experiments here
%             d.nfs = [4, 7, 10];
        end;
    end;
end
