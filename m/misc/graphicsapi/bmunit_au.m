%> @brief Unit - Arbitrary
%> @ingroup graphicsapi
%>
%> @sa bmtable
classdef bmunit_au < bmunit
    methods
        function o = bmunit_au(o)
            o.classtitle = 'Arbitrary Units';
            o.yformat = '%4.2f';
            o.flag_zeroline = 1;
        end;
    end;
end
