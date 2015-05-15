%> @brief Base class for dataset mergers.
classdef blmisc_merge < blmisc
    methods
        function o = blmisc_merge(o)
            o.classtitle = 'Dataset Merge';
            o.flag_multiin = 1;
            o.flag_params = 0;
        end;
    end;
end

