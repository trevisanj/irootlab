%> @brief Normalization - Mean-centering
%>
%> This class was kept after pre_meanc was reorganized as a subclass of pre_norm_base, but won't appear in the GUI.
%>
%> @sa normaliz.m
classdef pre_norm_meanc < pre_norm_base
    methods
        function o = pre_norm_meanc(o)
            o.classtitle = 'Mean-centering';
            o.short = 'MeanC';
            o.types = 'c';
            o.flag_ui = 0;
        end;
    end;
end