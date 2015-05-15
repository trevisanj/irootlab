%> @brief Flips the means around a reference class
%>
%> This tool was derived from discussions with Valon. He wanted to have a quantitative measurement of effect for his dose-response papers.
%> However, sometimes the CONTROL class was in the middle of the scatter plots.
%>
%> It translates each class to the positive side, maintaining the same class structure, by making <code>X_class = X_class-class_mean+abs(class_mean)</code>
%>
%> @sa uip_pre_sub_refmean.m
classdef pre_flip_refmean < pre
    properties
        %> =1. Index of reference class (1-based = first class is class "1")
        idx_refclass = 1;
    end;
    
    methods
        function o = pre_flip_refmean(o)
            o.classtitle = 'Flip means around a reference class';
        end;
    end;
    
    methods(Access=protected)
        function data = do_use(o, data)
            me = mean(data.X(data.classes == (o.idx_refclass-1), :));
            
            data.X = data.X-repmat(me, data.no, 1);
            
            for i = 1:data.nc
                idxs = data.classes == i-1; % Indexes of spectra from class i-1
                Xtemp = data.X(idxs, :);
                
                no = size(Xtemp, 1);
                me = mean(Xtemp);
                
                % Translates the whole class to the positive side, maintaining the same
                data.X(idxs, :) = Xtemp-repmat(me, no, 1)+repmat(abs(me), no, 1);
            end;
        end;
    end;
end