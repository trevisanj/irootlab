%> @brief Normalization - Amide I peak
%>
%> @sa normaliz.m
classdef pre_norm_amide1 < pre_norm_base
    methods
        function o = pre_norm_amide1()
            o.classtitle = 'Amide I peak';
            o.short = 'AmideI';
            o.types = '1';
        end;
    end;
end