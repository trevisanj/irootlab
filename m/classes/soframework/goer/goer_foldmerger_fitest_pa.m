%> Runs a foldmerger_fitest class, which merges individual folds of a cross-validation into one single file - pairwise version
classdef goer_foldmerger_fitest_pa < goer_ni
    methods
        %> Constructor
        function o = setup(o)

            o.classname = 'foldmerger_fitest_pa';
        end;
    end;
end
