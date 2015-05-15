%> Runs a foldmerger_fitest class, which merges individual folds of a cross-validation into one single file - non-pairwise version
classdef goer_foldmerger_fitest_np_grag < goer_ni
    methods
        %> Constructor
        function o = setup(o)
            o.classname = 'foldmerger_fitest_np';
        end;

        function d = customize_session(o, d)
            d.oo.cubeprovider.flag_grag = 1;
        end;
    end;
end
