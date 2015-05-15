%> @brief Calls a method from input block
%>
%> Has a constructor to set string to evaluate.
%>
classdef methodcaller < block
    properties
        %> String to be eval()'d as 'input.%s'
        string = [];
    end;
    
    methods
        %> @param s String for the @c string property
        function o = methodcaller(s)
            if nargin < 1
                s = '';
            end;
            o.classtitle = 'Method caller';
            o.flag_ui = 0;
            o.flag_params = 0;
            o.flag_bootable = 0;
            o.flag_trainable = 0;
            o.string = s;
        end;
    end;
    
    methods(Access=protected)
        function out = do_use(o, input) %#ok<*INUSD,*STOUT>
            eval(sprintf('out = input.%s;', o.string));
        end;
    end;
end
