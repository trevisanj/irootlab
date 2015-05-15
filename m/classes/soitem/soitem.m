%> Base class for input and output of a sodesigner process
classdef soitem < irobj
    properties
        time_design = 0;
        dstitle;
        classlabels;
        %> This is important because each item may be processed on a different "lab"
        where;
    end;
    
    methods
        function o = soitem()
            o.classtitle = 'System Optimization Data Item';
            o.color = [244, 146, 29]/255;
            o.flag_ui = 0;
        end;
    end;
end