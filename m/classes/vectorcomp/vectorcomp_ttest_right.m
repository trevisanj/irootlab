%> Vector Comparer - paired t-test right tail
%
%> result is -log10(p_value)
%>
%> Right tail test:
%> @ H0: mean(v1-v2) < 0
%>
%> Please note that in the cross-test table (created by crosstest()), v1 corresponds to the row,
%> and v2 corresponds to the column.
%>
%> It does the test twice, the second time with reversed vectors. So, if one p-value is small, the other one is likely to be very high
classdef vectorcomp_ttest_right < vectorcomp
    properties
        %> Whether to make result as -log10(p_value)
        flag_logtake = 1;
    end;

    methods(Access=protected)
        function z = do_test(o, v1, v2)
            [dummy, z1] = ttest(v1, v2, 0.05, 'right');
            [dummy, z2] = ttest(v2, v1, 0.05, 'right');
            z = [z1, z2];
            if o.flag_logtake
                z = -log10(z);
            end;
        end;
    end;
    
    methods
        function o = vectorcomp_ttest_right(o)
            o.classtitle = 'T-Test right tail';
            o.flag_params = 0;
        end;
    end;
end
