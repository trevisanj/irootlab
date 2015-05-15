%> Runs a foldmerger_fitest class, which merges individual folds of a cross-validation into one single file - non-pairwise version
classdef goer_foldmerger_fitest_np < goer_ni
    methods
        %> Constructor
        function o = setup(o)

            o.classname = 'foldmerger_fitest_np';
        end;
    end;
end
