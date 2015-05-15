%> @file
%> @ingroup demo

%> @brief Demo cascade block: pre_norm_std -> blmisc_classlabels_hierarchy
classdef cascade_stdhie < block_cascade_base
    methods
        function o = cascade_stdhie()
            o.classtitle = 'Standardization->SelectClassLevels';
            o.flag_trainable = 0;
            o.blocks = {pre_norm_std(), blmisc_classlabels_hierarchy()};
        end;
    end;
end