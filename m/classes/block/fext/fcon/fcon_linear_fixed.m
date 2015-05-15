%> @brief Loadings vector specified directly
classdef fcon_linear_fixed < fcon_linear
    methods
        function o = fcon_linear_fixed(o)
            o.classtitle = 'Fixed';
            o.short = 'LT'; % "Linear Transform"
            o.flag_trainable = 0;
            o.flag_ui = 0;
        end;
    end;
end