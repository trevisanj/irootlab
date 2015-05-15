%> @brief Bypass block
%>
%> Use this block
classdef block_bypass < block
    methods
        function o = block_bypass(o)
            o.classtitle = 'Bypass';
            o.flag_bootable = 0;
            o.flag_trainable = 0;
            o.flag_ui = 0;
        end;
    end;
end