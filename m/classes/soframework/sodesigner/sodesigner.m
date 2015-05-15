%> System Optimization designer - base class
%>
%> This class has been almost completely stripped
classdef sodesigner < filesession
    methods(Abstract, Access=protected)
        out = do_design(o);
    end;

    methods(Access=protected)
        function o = do_go(o)
            t = tic();
            item = o.design();
            item.time_design = toc(t);
            item.where = get_computer_name();
            o.output = item;
        end;
    end;

    methods
        %> Default design behaviour is to call do_design()
        function out = design(o)
            out = o.do_design();
        end;
    end;
 end