%> @brief Pre-processing block base class
classdef pre < block
    methods
        function o = pre(o)
            o.classtitle = 'Pre-processing';
            o.color = [0, 204, 136]/255;
        end;
    end;
end
