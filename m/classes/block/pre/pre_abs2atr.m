%> @brief Converts AB -> ATR
%>
%> Assumes that the x-axis represents wavenumbers in cm^-1
%>
%> <h3>Reference<h3>
%> OPUS help
classdef pre_abs2atr < pre
    methods
        function o = pre_abs2atr(o)
            o.classtitle = 'Absorbance-to-ATR';
            o.flag_params = 0;
        end;
    end;
    
    methods(Access=protected)
        %> Applies block to dataset
        function data = do_use(o, data)
            data.X = data.X.*repmat(data.fea_x, data.no, 1)/1000;
        end;
    end;
end