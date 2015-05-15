%> @brief Cascade block: as_grades_fsg->as_fsel_grades->(extract_fsel)
classdef cascade_fsel_grades_fsg < block_cascade_base
    methods
        function o = cascade_fsel_grades_fsg()
            o.classtitle = 'Feature selection grades FSG';
            o.flag_trainable = 1;
            o.blocks = {as_grades_fsg, as_fsel_grades, methodcaller('extract_fsel()')};
        end;
    end;
end