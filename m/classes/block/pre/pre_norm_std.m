%> @brief Normalization - std Normalization - backward compatibility
%>
%> This class was kept after pre_std was reorganized as a subclass of pre_norm_base, but won't appear in the GUI.
%>
%> @sa normaliz.m
classdef pre_norm_std < pre_norm_base
    methods
        function o = pre_norm_std()
            o.classtitle = 'Standardization';
            o.short = 'Std';
            o.types = 's';
            o.flag_ui = 0;
        end;
    end;
end