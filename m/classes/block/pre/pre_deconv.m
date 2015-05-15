%> @brief Deconvolution
%>
%> @sa MATLAB's deconvolve() function
classdef pre_deconv < pre
    properties
        %> =[.5, 1., .5]. Odd-length filter.
        h = [.5, 1., .5];
    end;

    
    methods
        function o = pre_deconv()
            o.classtitle = 'Deconvolution';
            o.flag_ui = 0;
        end;
    end;
    
    methods(Access=protected)
        % Applies block to dataset
        function data = go_use(o, data)
            [data.X, data.fea_x] = deconvolve(data.X, data.fea_x, o.h);        
        end;
    end;
end

