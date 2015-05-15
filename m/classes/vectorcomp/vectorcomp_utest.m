%> Vector Comparer - Mann-Whitney's U-test
%>
%> It actually uses MATLAB's ranksum() function (Wilcoxon rank sum test), but the documentation says that this is equivalent to the
%> Mann-Whitney test
%>
%> A positive value means that the first vector is "better" than the second. A negative value means the opposite.
classdef vectorcomp_utest < vectorcomp
    properties
        %> Whether to make result as -log10(p_value)
        flag_logtake = 1;
    end;
    methods(Access=protected)
        function z = do_test(o, v1, v2)
            z = ranksum(v1, v2);
            if o.flag_logtake
                z = -log10(z);
            end;
            z = [z, -z];
            if mean(v1) < mean(v2)
                z = -z;
            end;
        end;
    end;
    
    methods
        function o = vectorcomp_utest(o)
            o.classtitle = 'U-Test';
            o.flag_params = 0;
        end;
    end;
end
