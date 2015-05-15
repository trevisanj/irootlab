%> @brief Normalization - Amide II peak
%>
%> @sa normaliz.m
classdef pre_norm_amide2 < pre_norm_base
    methods
        function o = pre_norm_amide2(o)
            o.classtitle = 'Amide II peak';
            o.short = 'AmideII';
            o.types = '2';
        end;
    end;
end