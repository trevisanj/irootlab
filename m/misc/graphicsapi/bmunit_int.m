%> @brief Unit - Integer
%> @ingroup graphicsapi
%>
%> @sa bmtable
classdef bmunit_int < bmunit
    methods
        function o = bmunit_int(o)
            o.classtitle = 'Integer';
            o.yformat = '%3d';
            o.flag_zeroline = 0;
        end;
    end;
end
