%> FHG - Fisher criterion
classdef goer_fhg_fisher < goer_1i
    methods
        function o = setup(o)
 % The input file is irrelevant, because it won't use a classifier anyway
            o.classname = 'fhg_fisher';
        end;

        function d = customize_session(o, d)
        end;
    end;
end
