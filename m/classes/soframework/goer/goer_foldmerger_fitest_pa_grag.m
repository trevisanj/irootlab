%> Runs a foldmerger_fitest class, which merges individual folds of a cross-validation into one single file - pairwise version
classdef goer_foldmerger_fitest_pa_grag < goer_ni
    methods
        %> Constructor
        function o = setup(o)
            o.classname = 'foldmerger_fitest_pa';
            o.oo.cubeprovider.flag_grag = 1;
        end;

        function d = customize_session(o, d)
            d.oo.cubeprovider.flag_grag = 1;
        end;
    end;
end
