%> @brief Covariance matrix
%>
%> @sa data_draw_covariance.m, uip_vis_cov.m
classdef vis_cov < vis
    properties
        %> 'c': covariance; 'w': within-class covarianne matrix; 'b': between-class covariance matrix
        type = 'c';
        data_hint;
        %> =0. WHether to invert
        flag_inv = 0;
    end;
    
    methods
        function o = vis_cov(o)
            o.classtitle = 'Covariance Matrix';
            o.inputclass = 'irdata';
            o.flag_params = 1;
        end;
    end;
        
    methods(Access=protected)
        function out = do_use(o, obj)
            out = [];
            
            if isempty(o.data_hint)
                y_ref = []; %mean(obj.X);
            else
                y_ref = mean(o.data_hint.X);
            end;
            
            data_draw_covariance(obj, o.type, y_ref, o.flag_inv);
            set_title(o.classtitle, obj);
        end;
    end;
end