%> Vector Comparer - Normalized Xor
%>
%> Measure of diversity. Vectors must be of same size. 
%>
%> <h3>References</h3>
%> L. I. Kuncheva, Combining Pattern Classifiers: Methods and Algorithms. Wiley, 2004.

classdef vectorcomp_xornorm < vectorcomp
    methods(Access=protected)
        function z = do_test(o, v1, v2)
            z = xor(v1, v2)/numel(v1);
        end;
    end;
    
    methods
        function o = vectorcomp_xornorm(o)
            o.classtitle = 'Normalized Xor';
            o.flag_params = 0;
        end;
    end;
end
