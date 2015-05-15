%> Vector Comparer - Difference between means
%>
%> Subtracts: mean(v1)-mean(v2)
%>
%> A positive value means that the first number is higher than the second.
classdef vectorcomp_difference < vectorcomp
    methods(Access=protected)
        function z = do_test(o, v1, v2)
            z = mean(v1)-mean(v2);
            z = [z, -z];
        end;
    end;
    
    methods
        function o = vectorcomp_difference(o)
            o.classtitle = 'Difference';
            o.flag_params = 0;
        end;
    end;
end
