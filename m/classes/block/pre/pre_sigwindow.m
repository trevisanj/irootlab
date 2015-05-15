%> @brief Applies sigmoid window to curves
%>
%> Kills smoothly values above and below range.
%>
%> the x* values are relative to data vars x. They are converted to indexes.
%>
%> Applies a window for the coefficients to have smooth transition
%> between their current values and zero.
%> I chose the sigmoid function 1/(1+e^(k*x)) because it is easy to use.
%>
%> @sa sigwindow.m, uip_pre_sigwindow.m
classdef pre_sigwindow < pre
    properties
        %> beginning and terminus of window, given in data.fea_x units
        range;
        %> length for sigmoid to go from 0.5 to .995 or .005 given in data.fea_x units
        width;
    end;
    
    methods
        function o = pre_sigwindow(o)
            o.classtitle = 'Sigmoid Window';
            o.flag_ui = 0;
        end;
    end;
    
    methods(Access=protected)
        
        
        %> Applies block to dataset
        function data = do_use(o, data)
        
            if isempty(o.range)
                range_ = data.fea_x([1, end]);
            else
                range_ = o.range;
            end;
            
                
        
            x_per_fea = abs((data.fea_x(end)-data.fea_x(1))/(data.nf-1)); % features may not be equally spaced along the x axis, this is a good average though
            idxs_range = v_x2ind(range_, data.fea_x); % features not to be zeroed
            scale = o.width/x_per_fea;


            X = data.X;
            X = sigwindowuni(X, idxs_range(1), scale);
            X = sigwindowuni(X, idxs_range(2), -scale);
            data.X = X;
        end;
    end;
end
