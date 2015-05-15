%> @brief Resampling - uses MATLAB's DSP Toolbox @c resample() function
%>
%> @sa uip_fcon_resample.m
classdef fcon_resample < fcon
    properties
        no_fea = 80;
    end;

    methods
        function o = fcon_resample(o)
            o.classtitle = 'Resampling';
        end;
    end;
    
    methods(Access=protected)
        function data = do_use(o, data)
            data.fea_x = linspace(data.fea_x(1), data.fea_x(end), o.no_fea);
            data.X = resample(data.X', o.no_fea, data.nf)';
        end;
    end;
end
